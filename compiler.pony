//Based on example from https://stdlib.ponylang.org/process--index
use "process"
use "files"

primitive Compiler
    fun apply(env: Env, assembly_file: File) =>
        let client = ProcessClient(env)
        let notifier: ProcessNotify iso = consume client
        try
            let command_path = FilePath(env.root as AmbientAuth, "/bin/gcc")?
            let args: Array[String] iso = recover Array[String](3) end
            let assembly_file_path = assembly_file.path.path
            let output_file_path = assembly_file_path.substring(0, assembly_file_path.rfind(".s")?)
            args.push("gcc")
            args.push(consume assembly_file_path)
            args.push("-o" + consume output_file_path)
            let vars: Array[String] iso = recover Array[String](2) end
            vars.push("HOME=/")
            vars.push("PATH=/bin")
            let auth = env.root as AmbientAuth
            let pm: ProcessMonitor = ProcessMonitor(auth, auth, consume notifier, command_path,
                consume args, consume vars)
            pm.done_writing()
        else
            env.err.print("Could not create FilePath!")
        end

class ProcessClient is ProcessNotify
    let env: Env

    new iso create (env': Env) =>
        env = env'

    fun ref stdout(process: ProcessMonitor ref, data: Array[U8] iso) =>
        let out = String.from_array(consume data)
        env.out.print("STDOUT: " + out)

    fun ref stderr(process: ProcessMonitor ref, data: Array[U8] iso) =>
        let err = String.from_array(consume data)
        env.err.print("STDERR: " + err)

    fun ref failed(process: ProcessMonitor ref, err: ProcessError) =>
        match err
        | ExecveError => env.out.print("ProcessError: ExecveError")
        | PipeError => env.out.print("ProcessError: PipeError")
        | ForkError => env.out.print("ProcessError: ForkError")
        | WaitpidError => env.out.print("ProcessError: WaitpidError")
        | WriteError => env.out.print("ProcessError: WriteError")
        | KillError => env.out.print("ProcessError: KillError")
        | CapError => env.out.print("ProcessError: CapError")
        | Unsupported => env.out.print("ProcessError: Unsupported")
        end

    fun ref dispose(process: ProcessMonitor ref, child_exit_code: I32) =>
        let code: I32 = consume child_exit_code
        env.out.print("Child exit code: " + code.string())