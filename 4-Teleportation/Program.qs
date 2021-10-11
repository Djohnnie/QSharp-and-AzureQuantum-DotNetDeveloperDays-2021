﻿namespace Teleportation
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;

    @EntryPoint()
    operation HelloQ() : Unit
    {        
        TeleportBit(true);
        TeleportBit(false);        
        TeleportBit(false);
        TeleportBit(true);

        use qMessage = Qubit();
        
        Ry(2.0*PI()/3.0, qMessage);
        TeleportQubit(qMessage);

        Reset(qMessage);
    }

    operation TeleportBit(message: Bool) : Unit
    {
        use qRegistry = Qubit[3];
        
        let qMessage = qRegistry[0];
        let qAlice = qRegistry[1];
        let qBob = qRegistry[2];

        // Set qubit to teleport to required state
        // based on random message.
        if( message )
        {
            X(qMessage);
        }

        // Entangle Alice and Bob qubits
        H(qAlice);
        CNOT(qAlice, qBob);

        // Entangle Alice and Message
        CNOT(qMessage, qAlice);
        H(qMessage);

        let bAlice = M(qAlice);
        if( bAlice == One )
        {
          X(qBob);
        }

        let bMessage = M(qMessage);
        if( bMessage == One )
        {
          Z(qBob);
        }

        let bBob = M(qBob);

        Message( "Teleported " + BoolAsString(message) + " to " + BoolAsString(bBob == One));

        // Reset unmeasured Qubits.
        Reset(qBob);
    }

    operation TeleportQubit(message: Qubit) : Unit
    {
        use qRegistry = Qubit[2];
        
        let qMessage = message;
        let qAlice = qRegistry[0];
        let qBob = qRegistry[1];

        // Write diagnostics
        DumpRegister("teleport-qMessage-before.txt", [qMessage]);
        DumpRegister("teleport-qAlice-before.txt", [qAlice]);
        DumpRegister("teleport-qBob-before.txt", [qBob]);

        // Entangle Alice and Bob qubits
        H(qAlice);
        CNOT(qAlice, qBob);

        // Entangle Alice and Message
        CNOT(qMessage, qAlice);
        H(qMessage);

        let bAlice = M(qAlice);
        if( bAlice == One )
        {
          X(qBob);
        }

        let bMessage = M(qMessage);
        if( bMessage == One )
        {
          Z(qBob);
        }

        // Write diagnostics
        DumpRegister("teleport-qMessage-after.txt", [qMessage]);
        DumpRegister("teleport-qAlice-after.txt", [qAlice]);
        DumpRegister("teleport-qBob-after.txt", [qBob]);
            
        // Reset unmeasured Qubits.
        Reset(qBob);
    }
}