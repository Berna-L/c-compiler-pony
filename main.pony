use "files"

actor Main
    new create(env: Env) =>
        try
            for arquivo in env.args.slice(1).values() do
                let path = FilePath(env.root as AmbientAuth, arquivo)?
                match OpenFile(path)
                | let file: File =>
                    env.out.print("=============================================\n" + 
                    "Iniciando tokenização do arquivo " + arquivo + 
                    "\n=============================================")

                    while file.errno() is FileOK do
                        try
                            let tokens = Lexer.tokenizer(String.from_array(file.read(file.size())))?
                            for token in tokens.values() do
                                env.out.print(token.string())
                            end
                            env.out.print("=============================================\n" + 
                            "Fim da tokenização do arquivo " + arquivo + 
                            "\n=============================================")                            
                            try
                                let ast = Parser(tokens)?
                                env.out.print(ast.string())
                                let assembly = Generator(ast)
                                env.out.print(assembly)
                            else
                                env.err.print("Erro durante o parse")
                            end
                        else
                            env.err.print("Erro durante a tokenização")
                        end
                    end

                else
                    env.err.print("Erro na leitura do arquivo" + arquivo)
                end
            end
        end