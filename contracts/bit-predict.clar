;; Title: 
;; BitPredict: Decentralized Prediction Markets on Bitcoin
;; Summary: 
;; A trustless prediction market platform secured by Bitcoin, enabling users to speculate on price movements using STX tokens
;; Description:
;; BitPredict is a Layer 2 prediction market protocol built on Stacks that leverages Bitcoin's security. Users can:
;; - Create markets for specific price prediction windows
;; - Stake STX on "up" or "down" price movements
;; - Earn proportional rewards for correct predictions
;; - Resolve markets through oracle-reported prices
;; Features include:
;; - 2% platform fee on winnings
;; - Minimum 1 STX stake requirement
;; - Fully transparent on-chain resolution
;; - Bitcoin-native compliance through Stacks L2
;; - Time-bound market periods with automatic resolution

;; Constants

;; Administrative
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))

;; Error codes
(define-constant err-not-found (err u101))
(define-constant err-invalid-prediction (err u102))
(define-constant err-market-closed (err u103))
(define-constant err-already-claimed (err u104))
(define-constant err-insufficient-balance (err u105))
(define-constant err-invalid-parameter (err u106))

;; State Variables

;; Platform configuration
(define-data-var oracle-address principal 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
(define-data-var minimum-stake uint u1000000) ;; 1 STX minimum stake
(define-data-var fee-percentage uint u2) ;; 2% platform fee
(define-data-var market-counter uint u0)

;; Data Maps

;; Market data structure
(define-map markets
    uint
    {
        start-price: uint,
        end-price: uint,
        total-up-stake: uint,
        total-down-stake: uint,
        start-block: uint,
        end-block: uint,
        resolved: bool
    }
)

;; User predictions tracking
(define-map user-predictions
    {market-id: uint, user: principal}
    {prediction: (string-ascii 4), stake: uint, claimed: bool}
)