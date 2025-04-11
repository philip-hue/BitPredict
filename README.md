# BitPredict: Decentralized Prediction Markets on Stacks

A Bitcoin-secured prediction market protocol enabling STX-based price speculation markets with automated resolution.

## Table of Contents

- [BitPredict: Decentralized Prediction Markets on Stacks](#bitpredict-decentralized-prediction-markets-on-stacks)
	- [Table of Contents](#table-of-contents)
	- [Overview](#overview)
	- [Key Features](#key-features)
		- [Market Mechanics](#market-mechanics)
		- [Economic Model](#economic-model)
		- [Technical Specs](#technical-specs)
	- [Contract Architecture](#contract-architecture)
		- [Core Data Structures](#core-data-structures)
		- [State Management](#state-management)
	- [Installation](#installation)
	- [Error Codes](#error-codes)
	- [Administrative Functions](#administrative-functions)
		- [Configuration Updates (Owner)](#configuration-updates-owner)
	- [Security Considerations](#security-considerations)
	- [Contributing](#contributing)

## Overview

BitPredict implements decentralized prediction markets on Stacks L2 with:

- Market creation with custom price/time parameters
- STX-based staking system (minimum 1 STX)
- Oracle-based market resolution
- Automated profit distribution with 2% platform fee
- Immutable record of all predictions
- Bitcoin-finalized transaction security

## Key Features

### Market Mechanics

- `create-market`: Initialize prediction windows (start/end blocks)
- `make-prediction`: Stake STX on price direction ("up"/"down")
- `resolve-market`: Oracle-reported price finalization
- `claim-winnings`: Automated payout calculation

### Economic Model

- **Minimum Stake**: 1 STX (configurable)
- **Platform Fee**: 2% on successful claims (adjustable)
- **Payout Formula**: `(User Stake / Total Winning Pool) * Total Pool * 0.98`

### Technical Specs

- Time-bound market periods (block height based)
- Principal-based access control
- STX-native asset handling
- Immutable prediction records
- Fail-safe error handling (7 error states)

## Contract Architecture

### Core Data Structures

```clarity
;; Market configuration
{
    start-price: uint,
    end-price: uint,
    total-up-stake: uint,
    total-down-stake: uint,
    start-block: uint,
    end-block: uint,
    resolved: bool
}

;; User prediction record
{
    prediction: (string-ascii 4),
    stake: uint,
    claimed: bool
}
```

### State Management

- `markets`: Map of market ID → market data
- `user-predictions`: Nested map of (market ID, principal) → prediction
- `market-counter`: Auto-incrementing market ID

## Installation

1. Install [Clarinet](https://docs.hiro.so/clarinet)
2. Clone repository:
   ```bash
   git clone https://github.com/philip-hue/BitPredict
   cd BitPredict
   ```
3. Start local devnet:
   ```bash
   clarinet integrate
   ```

## Error Codes

| Code | Constant                 | Description                    |
| ---- | ------------------------ | ------------------------------ |
| u100 | err-owner-only           | Unauthorized owner action      |
| u101 | err-not-found            | Invalid market/user prediction |
| u102 | err-invalid-prediction   | Non-'up'/'down' prediction     |
| u103 | err-market-closed        | Market inactive/expired        |
| u104 | err-already-claimed      | Duplicate reward claim         |
| u105 | err-insufficient-balance | Low STX balance                |
| u106 | err-invalid-parameter    | Invalid numeric input          |

## Administrative Functions

### Configuration Updates (Owner)

```clarity
;; Update oracle address
(set-oracle-address 'NEW_ADDRESS)

;; Modify minimum stake
(set-minimum-stake u2000000) ;; 2 STX

;; Adjust platform fee
(set-fee-percentage u3) ;; 3%

;; Withdraw fees
(withdraw-fees u5000000) ;; 5 STX
```

## Security Considerations

1. **Oracle Trust**: Resolution depends on designated oracle integrity
2. **Block Timing**: Market periods use Stacks block heights
3. **Fund Safety**:
   - STX held in contract until resolution
   - No withdrawal before market closure
   - Fee segregation during payout
4. **Testing**:
   - 100% test coverage recommended
   - Time manipulation tests for market phases
   - Edge case testing for fee calculations

## Contributing

1. Fork repository
2. Create feature branch (`git checkout -b feature/improvement`)
3. Commit changes (`git commit -am 'Add feature'`)
4. Push branch (`git push origin feature/improvement`)
5. Open Pull Request
