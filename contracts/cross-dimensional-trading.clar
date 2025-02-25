;; Cross-dimensional Trading Contract

(define-map trades
  { trade-id: uint }
  {
    from-universe: (string-ascii 32),
    to-universe: (string-ascii 32),
    resource-offered: (string-ascii 32),
    resource-requested: (string-ascii 32),
    quantity-offered: uint,
    quantity-requested: uint,
    status: (string-ascii 10)
  }
)

(define-data-var next-trade-id uint u0)

(define-public (create-trade (from-universe (string-ascii 32)) (to-universe (string-ascii 32)) (resource-offered (string-ascii 32)) (resource-requested (string-ascii 32)) (quantity-offered uint) (quantity-requested uint))
  (let
    ((trade-id (var-get next-trade-id)))
    (var-set next-trade-id (+ trade-id u1))
    (ok (map-set trades
      { trade-id: trade-id }
      {
        from-universe: from-universe,
        to-universe: to-universe,
        resource-offered: resource-offered,
        resource-requested: resource-requested,
        quantity-offered: quantity-offered,
        quantity-requested: quantity-requested,
        status: "open"
      }
    ))
  )
)

(define-public (accept-trade (trade-id uint))
  (match (map-get? trades { trade-id: trade-id })
    trade (ok (map-set trades
      { trade-id: trade-id }
      (merge trade { status: "completed" })
    ))
    (err u404)
  )
)

(define-read-only (get-trade (trade-id uint))
  (map-get? trades { trade-id: trade-id })
)

