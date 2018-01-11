use "regex"

primitive KeywordInt
    fun string(): String => "Keyword [int]"

primitive KeywordReturn
    fun string(): String => "Keyword [return]"

primitive OpenBrace
    fun string(): String => "{"

primitive CloseBrace
    fun string(): String => "}"

primitive OpenParenthesis
    fun string(): String => "("

primitive CloseParenthesis
    fun string(): String => ")"

primitive Semicolon
    fun string(): String => ";"

class Identifier
    let value: String ref

    new create(value': String ref) =>
        value = value'

    fun string(): String => "Identifier [" + value + "]"

class IntegerLiteral
    let value: String ref

    new create(value': String ref) =>
        value = value'

    fun string(): String => "Integer Literal [" + value + "]"

type Keyword is (KeywordInt | KeywordReturn)

type SingleCharacterToken is
    (OpenBrace
    | CloseBrace
    | OpenParenthesis
    | CloseParenthesis
    | Semicolon)

type MultiCharacterToken is
    (Keyword
    | Identifier
    | IntegerLiteral)

type Token is
    (SingleCharacterToken
    | MultiCharacterToken)

primitive Lexer
    fun tokenizer(codigo: String): Array[Token] =>
        var lista_tokens: Array[Token] = []
        var valor_token_atual: String ref = String
        try
            for caractere in codigo.values() do
                match caractere
                | ' ' =>
                    try
                        lista_tokens.push(encerra_token(valor_token_atual) as Token)
                    end
                    valor_token_atual = String
                | '\t' =>
                    try
                        lista_tokens.push(encerra_token(valor_token_atual) as Token)
                    end
                    valor_token_atual = String
                | '\n' =>
                    try
                        lista_tokens.push(encerra_token(valor_token_atual) as Token)
                    end
                    valor_token_atual = String
                | '{' =>
                    try
                        lista_tokens.push(encerra_token(valor_token_atual) as Token)
                    end
                    valor_token_atual = String
                    lista_tokens.push(OpenBrace)
                | '}' =>
                    try
                        lista_tokens.push(encerra_token(valor_token_atual) as Token)
                    end
                    valor_token_atual = String
                    lista_tokens.push(CloseBrace)
                | '(' =>
                    try
                        lista_tokens.push(encerra_token(valor_token_atual) as Token)
                    end
                    valor_token_atual = String
                    lista_tokens.push(OpenParenthesis)
                | ')' =>
                    try
                        lista_tokens.push(encerra_token(valor_token_atual) as Token)
                    end
                    valor_token_atual = String
                    lista_tokens.push(CloseParenthesis)
                | ';' =>
                    try
                        lista_tokens.push(encerra_token(valor_token_atual) as Token)
                    end
                    valor_token_atual = String
                    lista_tokens.push(Semicolon)
                else
                    valor_token_atual.push(caractere)
                end
            end
            lista_tokens.push(encerra_token(valor_token_atual) as Token)
        end
        lista_tokens

    fun encerra_token(valor_token_atual: String ref): (Token | None) =>
        try
            match valor_token_atual
            | "int" => return KeywordInt
            | "return" => return KeywordReturn
            | Regex("[a-zA-Z]\\w*")? => return Identifier(valor_token_atual)
            | Regex("[0-9]+")? => return IntegerLiteral(valor_token_atual)
            end
        end