﻿namespace Deutch
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;

    @EntryPoint()
    operation HelloQ() : Unit
	{
        let (result1A, result1B) = Deutsch(ConstantZero);
        Message( "Constant-0: " + BoolAsString(result1A) + ", " + BoolAsString(result1B));

        let (result2A, result2B) = Deutsch(ConstantOne);
        Message( "Constant-1: " + BoolAsString(result2A) + ", " + BoolAsString(result2B));

        let (result3A, result3B) = Deutsch(Identity);
        Message( "Identity: " + BoolAsString(result3A) + ", " + BoolAsString(result3B));

        let (result4A, result4B) = Deutsch(Negation);
        Message( "Negation: " + BoolAsString(result4A) + ", " + BoolAsString(result4B));
    }

    // qOutput:  |0> --- --- --- --- |0>
	// qInput :  |x> --- --- --- --- |x>
    operation ConstantZero (qOutput: Qubit, qInput: Qubit) : Unit
    {
    }

	// qOutput:  |0> --- --- -X- --- |1>
	// qInput :  |x> --- --- --- --- |x>
    operation ConstantOne (qOutput: Qubit, qInput: Qubit) : Unit
    {
        X(qOutput);
    }

	// qOutput:  |0> --- -O- --- --- |x>
	// qInput :  |x> --- -|- --- --- |x>
    operation Identity (qOutput: Qubit, qInput: Qubit) : Unit
    {
        CNOT(qInput, qOutput);
    }

	// qOutput:  |0> --- -O- -X- --- |!x>
	// qInput :  |x> --- -|- --- ---  |x>
    operation Negation (qOutput: Qubit, qInput: Qubit) : Unit
    {
		CNOT(qInput, qOutput);
		X(qOutput);
    }
	
	// qOutput:  |0> -X- -H- -BB- -H- -M- |!x>
	// qInput :  |x> -X- -H- -BB- -H- -M-  |x>
	operation Deutsch (blackbox: (Qubit, Qubit) => Unit) : (Bool, Bool)
	{
		mutable result = (false, false);
		use register = Qubit[2];
		
		let qOutput = register[0];
		let qInput = register[1];

		X(qOutput);
		X(qInput);

		H(qOutput);
		H(qInput);

		blackbox(qOutput, qInput);
				
		H(qOutput);
		H(qInput);

		let bOutput = M(qOutput);
		let bInput = M(qInput);

		set result = (bInput == One, bOutput == One);

		return result;
	}
}