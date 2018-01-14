primitive ProgramGenerator
    fun apply(program: Program): String =>
        FunctionGenerator(program.function)

primitive FunctionGenerator
    fun apply(function: Function): String =>
        "\t.globl " + function.id + "\n"
        + function.id + ":\n"
        + StatementGenerator(function.statement) 

primitive StatementGenerator
    fun apply(statement: Statement): String =>
        ExpressionGenerator(statement.expression)
        + "\tret\n"

primitive ExpressionGenerator
    fun apply(expression: Expression): String =>
        var string = TermGenerator(expression.lhs)
        var i: USize = 0
        try
            while i < expression.operator_array.size() do
                string = string + "\tpushl\t%eax\n"
                + TermGenerator(expression.rhs(i)?)
                + "\tpopl\t%ecx\n"
                match expression.operator_array(i)?
                | Addition =>
                    string = string + "\taddl %ecx, %eax\n"
                | Subtraction =>
                    string = string
                    + "\tsubl\t%eax, %ecx\n"
                    + "\tmovl\t%ecx, %eax\n"
                end
                i = i + 1
            end
        end
        string

primitive TermGenerator
    fun apply(term: Term): String =>
        var string = FactorGenerator(term.lhs)
        var i: USize = 0
        try
            while i < term.operator_array.size() do
                string = string + "\tpushl\t%eax\n"
                + FactorGenerator(term.rhs(i)?)
                + "\tpopl\t%ecx\n"
                match term.operator_array(i)?
                | Multiplication =>
                    string = string + "\timul\t%ecx, %eax\n"
                | Division =>
                    string = string
                    + "\tmovl\t$0, %edx\n"
                    + "\tmovl\t%eax, %ebx\n"
                    + "\tmovl\t%ecx, %eax\n"
                    + "\tidivl\t%ebx\n"
                end
                i = i + 1
            end
        end
        string

primitive FactorGenerator
    fun apply(factor: Factor): String =>
        match factor
        | let expression: Expression => ExpressionGenerator(expression)
        | let operation: UnaryOperation => UnaryOperationGenerator(operation)
        | let constant: Constant => ConstantGenerator(constant)
        end

primitive UnaryOperationGenerator
    fun apply(operation: UnaryOperation): String =>
        FactorGenerator(operation.factor)
        + UnaryOperatorGenerator(operation.operator)

primitive UnaryOperatorGenerator
    fun apply(operator: UnaryOperator): String =>
        match operator
        | Negation => "\tneg\t%eax\n"
        | BitwiseComplement => "\tnot\t%eax\n"
        | LogicalNegation =>
            "\tcmpl\t$0, %eax\n"
            + "\tmovl\t$0, %eax\n"
            + "\tsete %al\n"
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