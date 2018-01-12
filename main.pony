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
                            for token in Lexer.tokenizer(String.from_array(file.read(file.size())))?.values() do
                                env.out.print(token.string())
                            end
                        else
                            env.err.print("Erro durante a tokenização")
                        end
                    end
                    env.out.print("=============================================\n" + 
                    "Fim da tokenização do arquivo " + arquivo + 
                    "\n=============================================")
                else
                    env.err.print("Erro na leitura do arquivo" + arquivo)
                end
            end
        end