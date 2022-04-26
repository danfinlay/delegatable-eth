pragma solidity ^0.8.13;
// SPDX-License-Identifier: MIT

import "./ECRecovery.sol";
import "hardhat/console.sol";

// BEGIN EIP712 AUTOGENERATED SETUP
struct EIP712Domain {
  string name;
  string version;
  uint256 chainId;
  address verifyingContract;
}

bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");

struct Invocation {
  Transaction transaction;
  ReplayProtection replayProtection;
  SignedDelegation[] authority;
}

bytes32 constant INVOCATION_TYPEHASH = keccak256("Invocation(Transaction transaction,ReplayProtection replayProtection,SignedDelegation[] authority)Caveat(address enforcer,bytes terms)Delegation(address delegate,bytes32 authority,Caveat[] caveats)ReplayProtection(uint256 nonce,uint256 queue)SignedDelegation(Delegation delegation,bytes signature)Transaction(address to,uint256 gasLimit,bytes data)");

struct Invocations {
  Invocation[] batch;
}

bytes32 constant INVOCATIONS_TYPEHASH = keccak256("Invocations(Invocation[] batch)Caveat(address enforcer,bytes terms)Delegation(address delegate,bytes32 authority,Caveat[] caveats)Invocation(Transaction transaction,ReplayProtection replayProtection,SignedDelegation[] authority)ReplayProtection(uint256 nonce,uint256 queue)SignedDelegation(Delegation delegation,bytes signature)Transaction(address to,uint256 gasLimit,bytes data)");

struct SignedInvocation {
  Invocations invocations;
  bytes signature;
}

bytes32 constant SIGNEDINVOCATION_TYPEHASH = keccak256("SignedInvocation(Invocations invocations,bytes signature)Caveat(address enforcer,bytes terms)Delegation(address delegate,bytes32 authority,Caveat[] caveats)Invocation(Transaction transaction,ReplayProtection replayProtection,SignedDelegation[] authority)Invocations(Invocation[] batch)ReplayProtection(uint256 nonce,uint256 queue)SignedDelegation(Delegation delegation,bytes signature)Transaction(address to,uint256 gasLimit,bytes data)");

struct Transaction {
  address to;
  uint256 gasLimit;
  bytes data;
}

bytes32 constant TRANSACTION_TYPEHASH = keccak256("Transaction(address to,uint256 gasLimit,bytes data)");

struct ReplayProtection {
  uint256 nonce;
  uint256 queue;
}

bytes32 constant REPLAYPROTECTION_TYPEHASH = keccak256("ReplayProtection(uint256 nonce,uint256 queue)");

struct Delegation {
  address delegate;
  bytes32 authority;
  Caveat[] caveats;
}

bytes32 constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegate,bytes32 authority,Caveat[] caveats)Caveat(address enforcer,bytes terms)");

struct Caveat {
  address enforcer;
  bytes terms;
}

bytes32 constant CAVEAT_TYPEHASH = keccak256("Caveat(address enforcer,bytes terms)");

struct SignedDelegation {
  Delegation delegation;
  bytes signature;
}

bytes32 constant SIGNEDDELEGATION_TYPEHASH = keccak256("SignedDelegation(Delegation delegation,bytes signature)Caveat(address enforcer,bytes terms)Delegation(address delegate,bytes32 authority,Caveat[] caveats)");

// END EIP712 AUTOGENERATED SETUP

error InvalidSignature (uint invocationIndex);

abstract contract CaveatEnforcer {
  function enforceCaveat (bytes calldata terms, Transaction calldata tx) virtual public returns (bool);
}
  
abstract contract Delegatable is ECRecovery {
  
    // This value MUST be set in the constructor of the form:
    // domainHash = getEIP712DomainHash('MyContractName','1',block.chainid,address(this));
    bytes32 public immutable domainHash;
  
    constructor (string memory contractName, string memory version) {
      domainHash = getEIP712DomainHash(contractName,version,block.chainid,address(this));
    }  

  // BEGIN EIP712 AUTOGENERATED BODY. See scripts/typesToCode.js

  function GET_EIP712DOMAIN_PACKETHASH (EIP712Domain memory _input) public pure returns (bytes32) {
    
    bytes memory encoded = abi.encode(
      EIP712DOMAIN_TYPEHASH,
      _input.name,
      _input.version,
      _input.chainId,
      _input.verifyingContract
    );
    
    return keccak256(encoded);
  }

  function GET_INVOCATION_PACKETHASH (Invocation memory _input) public pure returns (bytes32) {
    
    bytes memory encoded = abi.encode(
      INVOCATION_TYPEHASH,
      GET_TRANSACTION_PACKETHASH(_input.transaction),
      GET_REPLAYPROTECTION_PACKETHASH(_input.replayProtection),
      GET_SIGNEDDELEGATION_ARRAY_PACKETHASH(_input.authority)
    );
    
    return keccak256(encoded);
  }

  function GET_SIGNEDDELEGATION_ARRAY_PACKETHASH (SignedDelegation[] memory _input) public pure returns (bytes32) {
    bytes memory encoded;
    for (uint i = 0; i < _input.length; i++) {
      encoded = bytes.concat(
        encoded,
        GET_SIGNEDDELEGATION_PACKETHASH(_input[i])
      );
    }
    
    bytes32 hash = keccak256(encoded);
    return hash;
  }

  function GET_INVOCATIONS_PACKETHASH (Invocations memory _input) public pure returns (bytes32) {
    
    bytes memory encoded = abi.encode(
      INVOCATIONS_TYPEHASH,
      GET_INVOCATION_ARRAY_PACKETHASH(_input.batch)
    );
    
    return keccak256(encoded);
  }

  function GET_INVOCATION_ARRAY_PACKETHASH (Invocation[] memory _input) public pure returns (bytes32) {
    bytes memory encoded;
    for (uint i = 0; i < _input.length; i++) {
      encoded = bytes.concat(
        encoded,
        GET_INVOCATION_PACKETHASH(_input[i])
      );
    }
    
    bytes32 hash = keccak256(encoded);
    return hash;
  }

  function GET_SIGNEDINVOCATION_PACKETHASH (SignedInvocation memory _input) public pure returns (bytes32) {
    
    bytes memory encoded = abi.encode(
      SIGNEDINVOCATION_TYPEHASH,
      GET_INVOCATIONS_PACKETHASH(_input.invocations),
      keccak256(_input.signature)
    );
    
    return keccak256(encoded);
  }

  function GET_TRANSACTION_PACKETHASH (Transaction memory _input) public pure returns (bytes32) {
    
    bytes memory encoded = abi.encode(
      TRANSACTION_TYPEHASH,
      _input.to,
      _input.gasLimit,
      keccak256(_input.data)
    );
    
    return keccak256(encoded);
  }

  function GET_REPLAYPROTECTION_PACKETHASH (ReplayProtection memory _input) public pure returns (bytes32) {
    
    bytes memory encoded = abi.encode(
      REPLAYPROTECTION_TYPEHASH,
      _input.nonce,
      _input.queue
    );
    
    return keccak256(encoded);
  }

  function GET_DELEGATION_PACKETHASH (Delegation memory _input) public pure returns (bytes32) {
    
    bytes memory encoded = abi.encode(
      DELEGATION_TYPEHASH,
      _input.delegate,
      _input.authority,
      GET_CAVEAT_ARRAY_PACKETHASH(_input.caveats)
    );
    
    return keccak256(encoded);
  }

  function GET_CAVEAT_ARRAY_PACKETHASH (Caveat[] memory _input) public pure returns (bytes32) {
    bytes memory encoded;
    for (uint i = 0; i < _input.length; i++) {
      encoded = bytes.concat(
        encoded,
        GET_CAVEAT_PACKETHASH(_input[i])
      );
    }
    
    bytes32 hash = keccak256(encoded);
    return hash;
  }

  function GET_CAVEAT_PACKETHASH (Caveat memory _input) public pure returns (bytes32) {
    
    bytes memory encoded = abi.encode(
      CAVEAT_TYPEHASH,
      _input.enforcer,
      keccak256(_input.terms)
    );
    
    return keccak256(encoded);
  }

  function GET_SIGNEDDELEGATION_PACKETHASH (SignedDelegation memory _input) public pure returns (bytes32) {
    
    bytes memory encoded = abi.encode(
      SIGNEDDELEGATION_TYPEHASH,
      GET_DELEGATION_PACKETHASH(_input.delegation),
      keccak256(_input.signature)
    );
    
    return keccak256(encoded);
  }
// END EIP712 AUTOGENERATED BODY
  
    // Allows other contracts to call methods on this contract
    // Provided they have a valid SignedDelegation.
    function invoke (SignedInvocation[] calldata signedInvocations) public returns (bool success) {
      // console.log("Invoke called with %s invocations", signedInvocations.length);
  
      for (uint i = 0; i < signedInvocations.length; i++) {
        SignedInvocation calldata signedInvocation = signedInvocations[i];
        address invocationSigner = verifyInvocationSignature(signedInvocation);
        // console.log("Extracted invocation signer as %s", invocationSigner);
  
        for (uint x = 0; x < signedInvocation.invocations.batch.length; x++) {
          Invocation memory invocation = signedInvocation.invocations.batch[x];
          address intendedSender;
          address canGrant;

          // If there are no delegations, this invocation comes from the signer
          if (invocation.authority.length == 0) {
            console.log("No delegations, sending from invocation signer");
            intendedSender = invocationSigner;
            canGrant = intendedSender;
          }

          bytes32 authHash = 0x0;
  
          for (uint d = 0; d < invocation.authority.length; d++) {
            SignedDelegation memory signedDelegation = invocation.authority[d];
            address delegationSigner = verifyDelegationSignature(signedDelegation);

            // Implied sending account is the signer of the first delegation
            if (d == 0) {
              console.log("We have a delegation, sending from delegation signer %s", delegationSigner);
              intendedSender = delegationSigner;
              canGrant = intendedSender;
            }

            require(delegationSigner == canGrant, "Delegation signer does not match required signer");
  
            Delegation memory delegation = signedDelegation.delegation;
            require(delegation.authority == authHash, "Delegation authority does not match previous delegation");
  
            // Get the hash of this delegation, ensure that it has not been revoked.
            // Revokability is basically a "free" caveat I'm including. I know, it's more expensive. But it's safer.
            // TODO: Make sure this hash is sound, probably just use the 712 encoding. I did this quickly for MVP.
            // Also, maybe delegations should have replay protection, at least a nonce (non order dependent),
            // otherwise once it's revoked, you can't give the exact same permission again.
            bytes32 delegationHash = keccak256(abi.encode(signedDelegation));
            require(!isRevoked[delegationHash], "Delegation revoked");
  
            // TODO: Walk the Caveat array here.
            // Until this is added, the caveat array does nothing.
            for (uint16 y = 0; y < delegation.caveats.length; y++) {
              // Pass each to the target contract's caveat enforcer.
              // function enforceCaveat (bytes terms, Transaction tx) returns (bool);
            }
  
            // Store the hash of this delegation in `authHash`
            // That way the next delegation can be verified against it.
            authHash = delegationHash;
            canGrant = delegation.delegate;
            // console.log("Delegation chain has extended to %s", canGrant);
          }
  
          // And set the MsgSender to the original delegator.
          // console.log("Because of all that work, we are setting msg sender to %s", invocationSigner);
          require(invocationSigner == canGrant, "Signer was not delegated to.");

          // Here we perform the requested invocation.
          Transaction memory transaction = invocation.transaction;
          //console.log("Trying out this transaction from %s to %s", transaction.from, tx.to);
          //console.logBytes(tx.data);
  
          require(transaction.to == address(this), "Invocation target does not match");
          success = execute(
            transaction.to,
            transaction.data,
            transaction.gasLimit,
            intendedSender
          );
          require(success, "Delegator execution failed");
        }
      }
    }
  
    function execute(
        address to,
        bytes memory data,
        uint256 gasLimit,
        address sender
    ) internal returns (bool success) {
      bytes memory full = abi.encodePacked(data, sender);
      assembly {
        success := call(gasLimit, to, 0, add(full, 0x20), mload(full), 0, 0)
      }
    }
  
    // Allows any delegator to revoke any outstanding SignedDelegation,
    // Adding it to a revoked list,
    // invalidating any future invocations that would rely on it.
    mapping(bytes32 => bool) isRevoked;
    function revoke (SignedDelegation[] calldata delegations) public {
      for (uint i = 0; i < delegations.length; i++) {
        SignedDelegation calldata signedDelegation = delegations[i];
        address delegationSigner = verifyDelegationSignature(signedDelegation);
        address sender = _msgSender();
        require(delegationSigner == sender, "Revocations must be signed by the delegator");
        bytes32 delegationHash = keccak256(abi.encode(signedDelegation));
        isRevoked[delegationHash] = true;
      }
    }
  
    function verifyInvocationSignature (SignedInvocation memory signedInvocation) public view returns (address) {
      bytes32 sigHash = getInvocationsTypedDataHash(signedInvocation.invocations);
      // console.log("Invocation signature hash:");
      // console.logBytes32(sigHash);
      address recoveredSignatureSigner = recover(sigHash, signedInvocation.signature);
      return recoveredSignatureSigner;
    } 
  
    function verifyDelegationSignature (SignedDelegation memory signedDelegation) public view returns (address) {
      Delegation memory delegation = signedDelegation.delegation;
      bytes32 sigHash = getDelegationTypedDataHash(delegation);
      // console.log("Delegation signature hash:");
      // console.logBytes32(sigHash);
      // console.log("Delegation signature:");
      // console.logBytes(signedDelegation.signature);
  
      address recoveredSignatureSigner = recover(sigHash, signedDelegation.signature);
      // console.log("Recovered delegation signer: %s", recoveredSignatureSigner);
      return recoveredSignatureSigner;
    }
  
    function getDelegationTypedDataHash(Delegation memory delegation) public view returns (bytes32) {
      bytes32 digest = keccak256(abi.encodePacked(
        "\x19\x01",
        domainHash,
        GET_DELEGATION_PACKETHASH(delegation)
      ));
      // console.log("Produces the typed data hash digest");
      // console.logBytes32(digest);
      return digest;
    }

    function getInvocationsTypedDataHash (Invocations memory invocations) public view returns (bytes32) {
      bytes32 digest = keccak256(abi.encodePacked(
        "\x19\x01",
        domainHash,
        GET_INVOCATIONS_PACKETHASH(invocations)
      ));
      return digest;
    }
  
    function getEIP712DomainHash(string memory contractName, string memory version, uint256 chainId, address verifyingContract) public pure returns (bytes32) {
      // console.log("The getEIP712TypeHash() is:");
      // console.logBytes32(EIP712DOMAIN_TYPEHASH);
      bytes memory encoded = abi.encode(
        EIP712DOMAIN_TYPEHASH,
        keccak256(bytes(contractName)),
        keccak256(bytes(version)),
        chainId,
        verifyingContract
      );
      // console.log("The encoded EIP712 domain is:");
      // console.logBytes(encoded);
      return keccak256(encoded);
    } 

    function _msgSender () internal view virtual returns (address sender) {
      if(msg.sender == address(this)) {
        bytes memory array = msg.data;
        uint256 index = msg.data.length;
        assembly {
          // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
          sender := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
        }
      } else {
        sender = msg.sender;
      }
      return sender;
    }
  }
  
  