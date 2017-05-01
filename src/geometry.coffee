export default {
  distance: (a,b)->
    x = a[0] - b[0]
    y = a[1] - b[1]
    Math.sqrt(x*x + y*y)
  translation: (a, b)->
  scale: (a,b)->
    if a.length > 1 and b.length > 1
      d1 = @distance(a[0], a[1])
      d2 = @distance(b[0], b[1])
      2.0 * (d1-d2) / (d1+d2)
    else
      0.0
  translation: (a,b)->
    return [0, 0] if a.length == 0 or b.length == 0
    if a.length >=2 and b.length >= 2
      @translation([@barycentre(a)], [@barycentre(b)])
    else
      return [b[0][0] - a[0][0], b[0][1] - a[0][1]]
  barycentre: (points)->
    x = 0
    y = 0
    for point in points
      x += point[0]
      y += point[1]
    [ x / points.length, y / points.length ]
}
