Extension { #name : 'SmallInteger' }

{ #category : '*Presize' }
SmallInteger >> howManyOf: n [

    | count me |
    self = 0 ifTrue: [ ^ 0 ].

    count := 1.
    me := self - n.
    [ me > 0 ] whileTrue: [
            me := me - n.
            count := count + 1 ].
    ^ (count * n)
]
