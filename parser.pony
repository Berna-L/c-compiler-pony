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
    let lhs: Term
    let operator_array: Array[LowPrecedenceBinaryOperator]
    let rhs: Array[Term]

    new create(lhs': Term, operator_array': Array[LowPrecedenceBinaryOperator], rhs': Array[Term]) ? =>
        lhs = lhs'
        if (operator_array'.size() == rhs'.size()) then
            operator_array = operator_array'
            rhs = rhs'
        else error end

    fun string(): String =>
        var return_value = "(" + lhs.string()
        var i: USize = 0
        try
            while i < operator_array.size() do
                return_value = return_value + " " + operator_array(i)?.string() + " " + rhs(0)?.string()
                i = i + 1
            end
        end
        return_value + ")"

class Term
    let lhs: Factor
    let operator_array: Array[HighPrecedenceBinaryOperator]
    let rhs: Array[Factor]

    new create(lhs': Factor, operator_array': Array[HighPrecedenceBinaryOperator], rhs': Array[Factor]) ? =>
        lhs = lhs'
        if (operator_array'.size() == rhs'.size()) then
            operator_array = operator_array'
            rhs = rhs'
        else error end

    fun string(): String =>
        var return_value = lhs.string()
        var i: USize = 0
        try
            while i < operator_array.size() do
                return_value = return_value + " " + operator_array(i)?.string() + " " + rhs(0)?.string()
                i = i + 1
            end
        end
        return_value

class UnaryOperation
    let operator: UnaryOperator
    let factor: Factor

    new create (operator': UnaryOperator, factor': Factor) =>
        operator = operator'
        factor = factor'

    fun string(): String => operator.string() + factor.string()

class Constant
    let int: USize

    new create(int': USize) =>
        int = int'

    fun string(): String => "Int<" + int.string() + ">"

type Factor is
    (Expression
    | UnaryOperation
    | Constant)

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
        let lhs = TermParser(token_array)?
        let operator_array: Array[LowPrecedenceBinaryOperator] = []
        let rhs: Array[Term] = []
        var continue_loop = true
        try
            while continue_loop do
                let operator = token_array(0)? as LowPrecedenceBinaryOperator
                operator_array.push(operator)
                token_array.delete(0)?
                rhs.push(TermParser(token_array)?)
            end
        else continue_loop = false
        end
        Expression(lhs, operator_array, rhs)?

primitive TermParser
    fun apply(token_array: Array[Token]): Term ? =>
        let lhs = FactorParser(token_array)?
        let operator_array: Array[HighPrecedenceBinaryOperator] = []
        let rhs: Array[Factor] = []
        var continue_loop = true
        try
            while continue_loop do
                let operator = token_array(0)? as HighPrecedenceBinaryOperator
                operator_array.push(operator)
                token_array.delete(0)?
                rhs.push(FactorParser(token_array)?)
            end
        else continue_loop = false
        end
        Term(lhs, operator_array, rhs)?

primitive FactorParser
    fun apply(token_array: Array[Token]): Factor ? =>
        match token_array(0)?
        | OpenParenthesis =>
            token_array.shift()? as OpenParenthesis
            let expression = ExpressionParser(token_array)?
            token_array.shift()? as CloseParenthesis
            expression
        | let unary: UnaryOperator => UnaryOperationParser(token_array)?
        | let literal: IntegerLiteral => ConstantParser(token_array)?
        else error end

primitive UnaryOperationParser
    fun apply(token_array: Array[Token]): UnaryOperation ? =>
        let operator = token_array.shift()? as UnaryOperator
        let expression = FactorParser(token_array)?
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
