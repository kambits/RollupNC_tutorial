include "../circomlib/circuits/eddsamimc.circom";
include "../circomlib/circuits/mimc.circom";

template VerifyEdDSAMiMC(k) {

    // k is length of preimage

    signal input from_x;
    signal input from_y;
    signal input R8x;
    signal input R8y;
    signal input S;
    signal input preimage[k];
    
    component M = MultiMiMC7(k,91);
    for (var i = 0; i < k; i++){
        M.in[i] <== preimage[i];
    }
    M.k <== k;
    
    component verifier = EdDSAMiMCVerifier();   
    verifier.enabled <== 1;
    verifier.Ax <== from_x;
    verifier.Ay <== from_y;
    verifier.R8x <== R8x;
    verifier.R8y <== R8y;
    verifier.S <== S;
    verifier.M <== M.out;
}

component main {public [from_x, from_y, R8x, R8y, S]} = VerifyEdDSAMiMC(3);