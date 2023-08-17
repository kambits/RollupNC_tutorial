# What you'll need
1. Install node v10.16.0 possibly using NVM
2. Install circom follow the guide: https://docs.circom.io/getting-started/installation/
3. Install snarkjs follow the guide: https://github.com/iden3/snarkjs#install-snarkjs


# Clone
Clone this repo
```
$ git clone https://github.com/vaibhavchellani/RollupNC_tutorial
```
Clone the submodules:
```
$ cd RollupNC_tutorial
$ git submodule update --init --recursive
```

# Tutorial
## 1. Compiling circom circuits
Compiles your circuit and generates compiled circuit in r1sc and wasm format for snarkjs to use.
```
$ circom <your_circuit_name>.circom --r1cs --wasm
```
`r1cs`: generates `circuit.r1cs` (the r1cs constraint system of the circuit in binary format).

`wasm`: generates `circuit.wasm` (the wasm code to generate the witness – more on that later).

## 2. Generate inputs for your circuit
Generates public private inputs for your circuit
```
$ node generate_circuit_input.js
Note: This exists only for the course of our workshop
```

## 3. Calculate witness
Generates witness for your circuit using the compiled circuit and input file created in the above step
```
$ cd <your_circuit_name>.js
$ node generate_witness.js <your_circuit_name>.wasm ../input.json ../witness.wtns
```

## 4. Using PLONK or FFPLONK

### 4.1 Setup
Remember the infamous "Trusted Setup", to perform trusted setup on your device for a circuit use the below command. It creates a Proving and Verification key for your circuit.

If using PLONK:

```
$ snarkjs plonk setup <your_circuit_name>.r1cs ../powersOfTau28_hez_final_08.ptau circuit_final.zkey
```
If using FFPLONK:
```
$ snarkjs fflonk setup <your_circuit_name>.r1cs ../powersOfTau28_hez_final_08.ptau circuit_final.zkey
```

### 4.2 Export the verification key
```
$ snarkjs zkey export verificationkey circuit_final.zkey verification_key.json
```

### 4.3 Create the proof
If using PLONK:
```
$ snarkjs plonk prove circuit_final.zkey witness.wtns proof.json public.json
```
If using FFPLONK:
```
$ snarkjs fflonk prove circuit_final.zkey witness.wtns proof.json public.json
```
### 4.4 Verify the proof
If using PLONK:
```
$ snarkjs plonk verify verification_key.json public.json proof.json
```
If using FFPLONK:
```
$ snarkjs fflonk verify verification_key.json public.json proof.json
```

## 5.Using Groth16
### 5.1 Setup
```
$ snarkjs groth16 setup <your_circuit_name>.r1cs ../powersOfTau28_hez_final_08.ptau circuit_0000.zkey
```
IMPORTANT: Do not use this zkey in production, as it's not safe. It requires at least a contribution.
Note that circuit_0000.zkey (the output of the zkey command above) does not include any contributions yet, so it cannot be used in a final circuit.

### 5.2 Contribute to the phase 2 ceremony
```
$ snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor Name" -v
```
You'll be prompted to enter some random text to provide an extra source of entropy.

### 5.3 Provide a second contribution
```
$ snarkjs zkey contribute circuit_0001.zkey circuit_0002.zkey --name="Second contribution Name" -v -e="Another random entropy"
```
### 5.4 Provide a third contribution using third party software
```
$ snarkjs zkey export bellman circuit_0002.zkey  challenge_phase2_0003
$ snarkjs zkey bellman contribute bn128 challenge_phase2_0003 response_phase2_0003 -e="some random text"
$ snarkjs zkey import bellman circuit_0002.zkey response_phase2_0003 circuit_0003.zkey -n="Third contribution name"
```

### 5.5 Verify the latest zkey
```
$ snarkjs zkey verify <your_circuit_name>.r1cs ../powersOfTau28_hez_final_08.ptau circuit_0003.zkey
```

### 5.6 Apply a random beacon
```
$ snarkjs zkey beacon circuit_0003.zkey circuit_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"
```
### 5.7 Verify the final zkey
```
$ snarkjs zkey verify <your_circuit_name>.r1cs ../powersOfTau28_hez_final_08.ptau  circuit_final.zkey
```

### 5.8 Export the verification key
```
$ snarkjs zkey export verificationkey circuit_final.zkey verification_key.json
```
### 5.9 Create the proof
```
$ snarkjs groth16 prove circuit_final.zkey witness.wtns proof.json public.json
```

### 5.10 Verify the proof
```
$ snarkjs groth16 verify verification_key.json public.json proof.json
```

## 6.Generate the solidity verifier
```
$ snarkjs zkey export solidityverifier circuit_final.zkey verifier.sol
```
## 7.Verifying the proof on-chain
```
$ snarkjs zkey export soliditycalldata public.json proof.json
```

# Zk Rollup Tutorial

Head over to : https://keen-noyce-c29dfa.netlify.com/#0

The commands in above tutorial is out of date due to circom and snarkjs upgrade.