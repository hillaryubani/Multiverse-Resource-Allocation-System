;; Inter-universal Resource Tracking Contract

(define-map universal-resources
  { universe-id: (string-ascii 32), resource-id: (string-ascii 32) }
  {
    quantity: uint,
    last-updated: uint
  }
)

(define-public (update-resource (universe-id (string-ascii 32)) (resource-id (string-ascii 32)) (quantity uint))
  (ok (map-set universal-resources
    { universe-id: universe-id, resource-id: resource-id }
    {
      quantity: quantity,
      last-updated: block-height
    }
  ))
)

(define-read-only (get-resource (universe-id (string-ascii 32)) (resource-id (string-ascii 32)))
  (map-get? universal-resources { universe-id: universe-id, resource-id: resource-id })
)

(define-read-only (check-resource-availability (universe-id (string-ascii 32)) (resource-id (string-ascii 32)) (required-quantity uint))
  (match (map-get? universal-resources { universe-id: universe-id, resource-id: resource-id })
    resource (>= (get quantity resource) required-quantity)
    false
  )
)

