primitive ProgramGenerator
    fun apply(program: Program): String =>
        FunctionGenerator(program.function)

primitive FunctionGenerator
    fun apply(function: Function): String =>
        ".global _" + function.id + "\n"
        + "_" + function.id + ":\n"
        + StatementGenerator(function.statement) 

primitive StatementGenerator
    fun apply(statement: Statement): String =>
        "movl\t$" + ExpressionGenerator(statement.expression) + ", %eax\n"
        + "ret"

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