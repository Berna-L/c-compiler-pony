use "regex"

primitive Lexer
    fun tokenizer(source: String): Array[Token]? =>
        var token_array: Array[Token] = []
        var current_token: String ref = String
        for char in source.values() do
            match char
            | ' ' =>
                let token = finalize_token(current_token = String)?
                try token_array.push(token as Token) end
            | '\t' =>
                let token = finalize_token(current_token = String)?
                try token_array.push(token as Token) end
            | '\n' =>
                let token = finalize_token(current_token = String)?
                try token_array.push(token as Token) end
            | '{' =>
                let token = finalize_token(current_token = String)?
                try token_array.push(token as Token) end
                token_array.push(OpenBrace)
            | '}' =>
                let token = finalize_token(current_token = String)?
                try token_array.push(token as Token) end
                token_array.push(CloseBrace)
            | '(' =>
                let token = finalize_token(current_token = String)?
                try token_array.push(token as Token) end
                token_array.push(OpenParenthesis)
            | ')' =>
                let token = finalize_token(current_token = String)?
                try token_array.push(token as Token) end
                token_array.push(CloseParenthesis)
            | ';' =>
                let token = finalize_token(current_token = String)?
                try token_array.push(token as Token) end
                token_array.push(Semicolon)
            else
                current_token.push(char)
            end
        end
        let token = finalize_token(current_token = String)?
        try token_array.push(token as Token) end
        token_array

    fun finalize_token(current_token: String ref): (Token | None) ? =>
        try
            match current_token
            | "int" => return KeywordInt
            | "return" => return KeywordReturn
            | Regex("[a-zA-Z]\\w*")? => return Identifier(current_token)
            | Regex("[0-9]+")? => return IntegerLiteral(current_token.usize()?)
            end
        else error end
        None