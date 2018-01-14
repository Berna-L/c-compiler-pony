use "files"

actor Main
    let env: Env

    new create(env': Env) =>
        env = env'
        try
            for file_path_string in env.args.slice(1).values() do
                let path = FilePath(env.root as AmbientAuth, file_path_string)?
                match OpenFile(path)
                | let source_file: File =>
                    if source_file.errno() is FileOK then
                        try
                            let tokens = Lexer.tokenizer(String.from_array(source_file.read(source_file.size())))?
                            try
                                let ast = Parser(tokens)?
                                let assembly = Generator(ast)
                                let assembly_file_path_string = file_path_string.substring(0, file_path_string.rfind(".c")?) + ".s"
                                let assembly_file_path = FilePath(env.root as AmbientAuth, assembly_file_path_string)?
                                match CreateFile(assembly_file_path)
                                | let assembly_file: File =>
                                    assembly_file.write(assembly)
                                    Compiler(env, assembly_file)
                                end
                            else
                                env.err.print("Error parsing source code from " + file_path_string)
                            end
                        else
                            env.err.print("Error tokenizing source code from " + file_path_string)
                        end
                    end

                else
                    env.err.print("Error reading file" + file_path_string)
                end
            end
        end