use "regex"

primitive Lexer
    fun tokenizer(codigo: String): Array[Token]? =>
        var lista_tokens: Array[Token] = []
        var valor_token_atual: String ref = String
        for caractere in codigo.values() do
            match caractere
            | ' ' =>
                let token = encerra_token(valor_token_atual = String)?
                try lista_tokens.push(token as Token) end
            | '\t' =>
                let token = encerra_token(valor_token_atual = String)?
                try lista_tokens.push(token as Token) end
            | '\n' =>
                let token = encerra_token(valor_token_atual = String)?
                try lista_tokens.push(token as Token) end
            | '{' =>
                let token = encerra_token(valor_token_atual = String)?
                try lista_tokens.push(token as Token) end
                lista_tokens.push(OpenBrace)
            | '}' =>
                let token = encerra_token(valor_token_atual = String)?
                try lista_tokens.push(token as Token) end
                lista_tokens.push(CloseBrace)
            | '(' =>
                let token = encerra_token(valor_token_atual = String)?
                try lista_tokens.push(token as Token) end
                lista_tokens.push(OpenParenthesis)
            | ')' =>
                let token = encerra_token(valor_token_atual = String)?
                try lista_tokens.push(token as Token) end
                lista_tokens.push(CloseParenthesis)
            | ';' =>
                let token = encerra_token(valor_token_atual = String)?
                try lista_tokens.push(token as Token) end
                lista_tokens.push(Semicolon)
            else
                valor_token_atual.push(caractere)
            end
        end
        let token = encerra_token(valor_token_atual = String)?
        try lista_tokens.push(token as Token) end
        lista_tokens

    fun encerra_token(valor_token_atual: String ref): (Token | None) ? =>
        try
            match valor_token_atual
            | "int" => return KeywordInt
            | "return" => return KeywordReturn
            | Regex("[a-zA-Z]\\w*")? => return Identifier(valor_token_atual)
            | Regex("[0-9]+")? => return IntegerLiteral(valor_token_atual.usize()?)
            end
        else error end
        None