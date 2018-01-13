primitive ProgramGenerator
    fun apply(program: Program): String =>
        FunctionGenerator(program.function) + "\n"

primitive FunctionGenerator
    fun apply(function: Function): String =>
        "\t.globl " + function.id + "\n"
        + function.id + ":\n"
        + StatementGenerator(function.statement) 

primitive StatementGenerator
    fun apply(statement: Statement): String =>
        "\tmovl\t$" + ExpressionGenerator(statement.expression) + ", %eax\n"
        + "\tret"

primitive ExpressionGenerator
    fun apply(expression: Expression): String =>
        expression.int.string()


primitive Generator
    fun apply(ast: AST): String =>
        match ast
        | let program: Program => ProgramGenerator(program)
        | let function: Function => FunctionGenerator(function)
        | let statement: Statement => StatementGenerator(statement)
        | let expression: Expression => ExpressionGenerator(expression)
        end