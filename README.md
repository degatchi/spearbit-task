# Spearbit Writing Exercise

## Wallet Protocol

You are given an implementation for a smart contract wallet. There are two contracts

1. [`Implementation.sol`](contracts/Implementation.sol): Deployed once and used as implementation contract in `Proxy.sol`.
2. [`Proxy.sol`](contracts/Proxy.sol): Each user has a unique `Proxy` deployment with the above implementation. This is a simply proxy contract which delegatecalls the implementation contract. It has an access control check that allows only the owner to use the fallback function.

The idea is that users can keep their funds, for example, ETH or ERC20 tokens in the Proxy. To use these funds, users can execute arbitrary calls and arbitrary delegatecalls by using the implementation contract (it has `callContract` and `delegatecallContract`). The implementation contract is deployed only once and reused to save gas.

There is a **critical bug** in the wallet protocol. The exercise is to find it and write it in markdown format, in accordance with the style guide.

For simplicity, we expect 

```md
## Short title for the issue

**Severity**: High / Medium / Low / Informational / Gas Optimisation

Context: [`File.sol#L123`](github.com/permalink)

Description of the attack.

**Recommendation**: Description on how to avoid the issue.
```

Reference: [Style guide for writing Spearbit reports](https://hackmd.io/@spearbit/S1T63tOqt).


*Bonus*: There is simple, yet niche technique to avoid the critical issue by modifying `Implementation.sol`. Bonus point if you can include this in your recommendation.

---

# Report

## Proxy denial of service (DOS)
**Severity**: High

**Context**: [`Implementation.sol#17`](https://github.com/spearbit-audits/writing-exercise/blob/develop/contracts/Implementation.sol#L17)

The `delegatecallContract(address a, byes calldata _calldata)` is able to be accessed by anyone, due to the lack of access control implementations. This allows anyone to deploy a contract with `selfdestruct()` then forwarding it to `Implementation.sol` via `_calldata` to remove all of it's bytecode, disabling all functionality. When disabled, any `Proxy.sol` using `Implementation.sol` is now permanently denied of access to their funds because it 1) relies on the now useless `Implementation.sol` (https://github.com/spearbit-audits/writing-exercise/blob/develop/contracts/Proxy.sol#L15) to execute transactions and 2) there is no state modifying function to change the `implementation` state to redirect to a different implementation.

**Recommendation**: 
- Add access control to restrict the Proxy's `implementation` contract to only being accessible to the single proxy.
- Add state modifying function for `implementation` to future proof and prevent events similar to this one from happening again.