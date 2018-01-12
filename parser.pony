class Program
    let function: Function

    new create(function' Function) =>
        function = function'

class Function
    let id: String
    let statement: Statement

    new create(id': String, statement': Statement) =>
        id = id'
        statement = statement'

class Statement
    let expression: Expression

    new create(expression': Expression) =>
        expression = expression'

class Expression
    let int: USize

    new create(int': Usize) =>
        int = int'

type AST is (
    Program
    | Function
    | Statement
    | Expression)

primitive Parser
    fun apply(tokens: Array[Tokens]): AST