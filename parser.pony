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

class UnaryOperation
    let operator: UnaryOperator
    let expression: Expression

    new create (operator': UnaryOperator, expression': Expression) =>
        operator = operator'
        expression = expression'

    fun string(): String => operator.string() + expression.string()

class Constant
    let int: USize

    new create(int': USize) =>
        int = int'

    fun string(): String => "Int<" + int.string() + ">"

type Expression is (UnaryOperation | Constant)

primitive ProgramParser
    fun apply(token_array: Array[Token]): Program ? =>
        Program(FunctionParser(token_array)?)

primitive FunctionParser
    fun apply(token_array: Array[Token]): Function ? =>
        token_array.shift()? as KeywordInt
        let idToken = token_array.shift()? as Identifier
        let identifier = idToken.value
        token_array.shift()? as OpenParenthesis
        token_array.shift()? as CloseParenthesis
        token_array.shift()? as OpenBrace
        let statement = StatementParser(token_array)?
        Function(identifier, statement)
        

primitive StatementParser
    fun apply(token_array: Array[Token]): Statement ? =>
        token_array.shift()? as KeywordReturn
        let expression = ExpressionParser(token_array)?
        token_array.shift()? as Semicolon
        Statement(expression)

primitive ExpressionParser
    fun apply(token_array: Array[Token]): Expression ? =>
        match token_array(0)?
        | let operator: UnaryOperator => UnaryOperationParser(token_array)?
        | let literal: IntegerLiteral => ConstantParser(token_array)?
        else error end

primitive UnaryOperationParser
    fun apply(token_array: Array[Token]): UnaryOperation ? =>
        let operator = token_array.shift()? as UnaryOperator
        let expression = ExpressionParser(token_array)?
        UnaryOperation(operator, expression)

primitive ConstantParser
    fun apply(token_array: Array[Token]): Constant ? =>
        let literal = token_array.shift()? as IntegerLiteral
        Constant(literal.value)

type AST is (
    Program
    | Function
    | Statement
    | Expression)

primitive Parser
    fun apply(token_array: Array[Token]): AST ? =>
        ProgramParser(token_array)?
