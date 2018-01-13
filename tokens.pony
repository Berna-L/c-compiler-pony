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

primitive Negation
    fun string(): String => "-"

primitive BitwiseComplement
    fun string(): String => "~"

primitive LogicalNegation
    fun string(): String => "!"

class Identifier
    let value: String ref

    new create(value': String ref) =>
        value = value'

    fun string(): String => "Identifier [" + value + "]"

class IntegerLiteral
    let value: USize

    new create(value': USize) =>
        value = value'

    fun string(): String => "Integer Literal [" + value.string() + "]"

type Keyword is (KeywordInt | KeywordReturn)

type UnaryOperator is
    (Negation
    | BitwiseComplement
    | LogicalNegation)

type SingleCharacterToken is
    (OpenBrace
    | CloseBrace
    | OpenParenthesis
    | CloseParenthesis
    | Semicolon
    | UnaryOperator)

type MultiCharacterToken is
    (Keyword
    | Identifier
    | IntegerLiteral)

type Token is
    (SingleCharacterToken
    | MultiCharacterToken)
