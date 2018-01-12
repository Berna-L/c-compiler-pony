class Program
    let function: Function

    new create(function': Function) =>
        function = function'

    fun string(): String => "Program <" + function.string() + ">"

class Function
    let id: String ref
    let statement: Statement

    new create(id': String ref, statement': Statement) =>
        id = id'
        statement = statement'

    fun string(): String => "int " + id + "() {" + statement.string() + "}"

class Statement
    let expression: Expression

    new create(expression': Expression) =>
        expression = expression'

    fun string(): String => "statement " + expression.string()

class Expression
    let int: USize

    new create(int': USize) =>
        int = int'

    fun string(): String => "return " + int.string() + ";"

primitive ProgramParser
    fun apply(tokens: Array[Token]): Program ? =>
        Program(FunctionParser(tokens)?)

primitive FunctionParser
    fun apply(tokens: Array[Token]): Function ? =>
       
        match tokens.shift()? | KeywordInt =>
            match tokens.shift()? | let idToken: Identifier =>
                let identifier = idToken.value
                match tokens.shift()? | OpenParenthesis =>
                    match tokens.shift()? | CloseParenthesis =>
                        match tokens.shift()? | OpenBrace =>
                            let statement = StatementParser(tokens)?
                            match tokens.shift()? | CloseBrace =>
                                return Function(identifier, statement)
                            else error end
                        else error end
                    else error end
                else error end
            else error end
        else error end

primitive StatementParser
    fun apply(tokens: Array[Token]): Statement ? =>
        match tokens.shift()? | KeywordReturn => 
            let expression = ExpressionParser(tokens)?
            match tokens.shift()? | Semicolon =>
                return Statement(expression)
            else error end
        else error end

primitive ExpressionParser
    fun apply(tokens: Array[Token]): Expression ? =>
        let token = tokens.shift()?
        match token | let literal: IntegerLiteral =>
            return Expression(literal.value)
        else error end


type AST is (
    Program
    | Function
    | Statement
    | Expression)

primitive Parser
    fun apply(tokens: Array[Token]): AST ? =>
        ProgramParser(tokens)?
