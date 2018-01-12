class Program
    let function: Function

    new create(function': Function) =>
        function = function'

    fun string(): String => function.string()

class Function
    let id: String ref
    let statement: Statement

    new create(id': String ref, statement': Statement) =>
        id = id'
        statement = statement'

    fun string(): String =>
        "FUN INT " + id + ":\n"
        + "\tparams: ()\n"
        + "\tbody:\n\t\t" + statement.string()

class Statement
    let expression: Expression

    new create(expression': Expression) =>
        expression = expression'

    fun string(): String => "RETURN " + expression.string()

class Expression
    let int: USize

    new create(int': USize) =>
        int = int'

    fun string(): String => "Int<" + int.string() + ">"

primitive ProgramParser
    fun apply(tokens: Array[Token]): Program ? =>
        Program(FunctionParser(tokens)?)

primitive FunctionParser
    fun apply(tokens: Array[Token]): Function ? =>
        tokens.shift()? as KeywordInt
        let idToken = tokens.shift()? as Identifier
        let identifier = idToken.value
        tokens.shift()? as OpenParenthesis
        tokens.shift()? as CloseParenthesis
        tokens.shift()? as OpenBrace
        let statement = StatementParser(tokens)?
        Function(identifier, statement)
        

primitive StatementParser
    fun apply(tokens: Array[Token]): Statement ? =>
        tokens.shift()? as KeywordReturn
        let expression = ExpressionParser(tokens)?
        tokens.shift()? as Semicolon
        Statement(expression)

primitive ExpressionParser
    fun apply(tokens: Array[Token]): Expression ? =>
        let literal = tokens.shift()? as IntegerLiteral
        Expression(literal.value)


type AST is (
    Program
    | Function
    | Statement
    | Expression)

primitive Parser
    fun apply(tokens: Array[Token]): AST ? =>
        ProgramParser(tokens)?
