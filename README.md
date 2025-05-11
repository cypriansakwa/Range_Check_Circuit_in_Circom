# 🛡️ Circom Range Check ZKP Circuit

This project demonstrates a **zero-knowledge proof** using [Circom](https://docs.circom.io) that validates whether a **public input `x` is within a specific range** `[10, 100]` — without revealing anything beyond the fact that the input satisfies this constraint.

---

## 🧩 Applications

This kind of range constraint is fundamental in many ZK applications such as:

- ✅ **Age Verification**: Prove that age ≥ 18 without revealing your actual age.
- 📦 **Private Auctions**: Ensure bids are within allowed bounds (e.g., `100 ≤ bid ≤ 1000`) without revealing the exact bid.
- 🔐 **Confidential Transactions**: Use range proofs to confirm that transaction amounts are non-negative and within expected limits, without disclosing the amounts.
- 🗳️ **ZK Voting Systems**: Enforce that a vote is among allowed discrete choices (e.g., vote ∈ {1, 2, 3}).
- 🎫 **Credential Validation**: Show compliance with thresholds (e.g., salary ≥ X for a loan application) while keeping personal data private.

These kinds of constraints are building blocks in real-world ZK systems, especially in **privacy-preserving identity, finance, and compliance protocols**.

---
## 📦 Installation

### 🔁 Clone the Repository

```bash
git clone https://github.com/cypriansakwa/Range_Check_Circuit_in_Circom.git
cd Range_Check_Circuit_in_Circom
```
## ⚙️ Install Dependencies

Make sure you have the following installed:

- [Node.js](https://nodejs.org/)
- [Circom](https://docs.circom.io/getting-started/installation/)
- [SnarkJS](https://github.com/iden3/snarkjs)

To install SnarkJS globally:

```bash
npm install -g snarkjs
```
## 📦 Project Structure
```text
Range_Check_Circuit_in_Circom/
│
├── range_check.circom              # Circom circuit code
├── input.json                      # JSON input for proof generation
├── witness.json                    # Witness generated from the circuit
├── verification_key.json           # Key used to verify the proof
├── proof.json                      # Proof output from snarkjs
├── public.json                     # Public inputs (for verifier)
├── Range_Check_Circuit_in_Circom_js/  # Auto-generated WASM & witness code
└── README.md                       # You're reading it!
```
```yaml

---

## 🧮 Circuit Logic

### ✅ Rust Equivalent
```rust
fn main(x: pub u32) {
    let lower_bound: u32 = 10;
    let upper_bound: u32 = 100;

    assert(x >= lower_bound);
    assert(x <= upper_bound);
}
```
```
## 🧠 Circom Translation

```circom
pragma circom 2.1.4;

template RangeCheck() {
    signal input x;

    var lower_bound = 10;
    var upper_bound = 100;

    signal lower_check;
    lower_check <== x - lower_bound;

    signal upper_check;
    upper_check <== upper_bound - x;
}

component main = RangeCheck();
```
## 🚀 How to Run
### 1. Prerequisites
- Node.js
- Circom
- SnarkJS
### 2. Compile the Circuit
```bash
circom range_check.circom --r1cs --wasm --sym
```
### 3. Generate Trusted Setup (Powers of Tau)
```bash
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
snarkjs powersoftau contribute pot12_0000.ptau pot12_final.ptau --name="First contribution" -v
```
### 4. Generate ZKey
```bash
snarkjs groth16 setup range_check.r1cs pot12_final.ptau range_check.zkey
```
### 5. Export Verification Key
```bash
snarkjs zkey export verificationkey range_check.zkey verification_key.json
```
### 6. Provide Input
Create a file named `input.json` with the following content:
```bash
{
  "x": 42
}
```
### 7. Generate Witness
```bash
node Range_Check_Circuit_in_Circom_js/generate_witness.js Range_Check_Circuit_in_Circom_js/range_check.wasm input.json witness.wtns
```
(Optional) Export witness to readable JSON:
```bash
snarkjs wtns export json witness.wtns witness.json
```
### 8. Generate Proof
```bash
snarkjs groth16 prove range_check.zkey witness.wtns proof.json public.json
```
### 9. Verify the Proof
```bash
snarkjs groth16 verify verification_key.json public.json proof.json
```
You should see:
```bash
OK!
```
## 🧪 Testing
### ✔️ Valid Case
```json
{
  "x": 42
}
```
### ❌ Invalid Case (Fails)
```json
{
  "x": 150
}
```
### 📖 Sample Output (witness.json)
```json
[
  "1",     // initialization
  "42",    // input x
  "32",    // x - 10 = 32
  "58"     // 100 - x = 58
]
```
## 🧰 Future Improvements
- Make lower_bound and upper_bound configurable as inputs
- Convert to private range check (prove without revealing x)
- Use custom comparators for non-fixed bounds
## 🤝 Acknowledgements

- [iden3](https://iden3.io) for Circom and SnarkJS.  
- Rust ↔ Circom inspiration drawn from the simplicity of ZKP logic in both languages.

