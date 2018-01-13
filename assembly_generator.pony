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
        ExpressionGenerator(statement.expression)
        + "\tret"

primitive ExpressionGenerator
    fun apply(expression: Expression): String =>
        match expression
        | let operation: UnaryOperation => UnaryOperationGenerator(operation)
        | let constant: Constant => ConstantGenerator(constant)
        end

primitive UnaryOperationGenerator
    fun apply(operation: UnaryOperation): String =>
        ExpressionGenerator(operation.expression)
        + UnaryOperatorGenerator(operation.operator)

primitive UnaryOperatorGenerator
    fun apply(operator: UnaryOperator): String =>
        match operator
        | Negation => "\tneg %eax\n"
        | BitwiseComplement => "\tnot %eax\n"
        | LogicalNegation =>
            "\tcmpl\t$0, %eax\n"
            + "\tmovl $0, %eax\n"
            + "sete %al\n"
        end

primitive ConstantGenerator
    fun apply(constant: Constant): String =>
        "\tmovl\t$" + constant.int.string() + ", %eax\n"

primitive Generator
    fun apply(ast: AST): String =>
        match ast
        | let program: Program => ProgramGenerator(program)
        | let function: Function => FunctionGenerator(function)
        | let statement: Statement => StatementGenerator(statement)
        | let expression: Expression => ExpressionGenerator(expression)
        end