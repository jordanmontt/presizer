Class {
	#name : 'Presizer',
	#superclass : 'IllAbstractProfiler',
	#instVars : [
		'traversalDepth',
		'samples',
		'instancesThatAreNotCollections'
	],
	#classVars : [
		'CollectionClassestoSpy'
	],
	#category : 'Presize-Objects',
	#package : 'Presize',
	#tag : 'Objects'
}

{ #category : 'accessing' }
Presizer class >> growableCollectionClasses [

    ^ {
        "Character collections"
        CharacterSet. WideCharacterSet.
        "Ordered collections"
        OrderedCollection. SortedCollection. Stack. Heap. KeyedTree.
        "Regular set collections"
        Set. PluggableSet.
        "Regular dictionary collections"
        Dictionary. SmallDictionary. OrderedDictionary. PluggableDictionary.
        "Identity collections"
        IdentitySet. IdentityDictionary. SmallIdentityDictionary. OrderedIdentityDictionary.
        "Weak collections"
        WeakSet. WeakOrderedCollection. WeakKeyDictionary. WeakValueDictionary.
        "Weak identity collections"
        WeakIdentitySet. WeakIdentityKeyDictionary. WeakIdentityValueDictionary }
]

{ #category : 'class initialization' }
Presizer class >> initialize [

    CollectionClassestoSpy := self growableCollectionClasses
]

{ #category : 'initialization' }
Presizer >> initialize [

    super initialize.
    instancesThatAreNotCollections := 0.
    samples := OrderedCollection new: 10000.
    traversalDepth := 80 "depth is half of the size, so 40 in this case. This is because the compiled method and the offset use two array positions. See registerAllocation: method"
]

{ #category : 'profiling' }
Presizer >> registerAllocation: newlyAllocatedObject [

    | filteredContext allocationPath i sample |

    (CollectionClassestoSpy includes: newlyAllocatedObject class) ifFalse: [
            instancesThatAreNotCollections := instancesThatAreNotCollections + 1.
            ^ newlyAllocatedObject ].

    i := 1.
    allocationPath := Array new: traversalDepth.

    filteredContext := thisContext "this method"
            sender "IllHandler >> #afterExecutionWithReceiver:returnValue:"
            sender "proxy method".

    "Get the allocation path until a limit n"
    [ filteredContext isNil or: [ i > traversalDepth ] ] whileFalse: [
            allocationPath
                at: i put: filteredContext compiledCode;
                at: i + 1 put: filteredContext pc - 1.
            i := i + 2.
            filteredContext := filteredContext sender ].

    sample := PresizerSample new
                  spiedCollectionInstance: newlyAllocatedObject;
                  allocationPath: allocationPath;
                  yourself.

    samples add: sample.

    ^ newlyAllocatedObject
]

{ #category : 'statistics' }
Presizer >> sizesDistributionGroupingBy: n [

    | groupingBlock |
    self assert: n > 0.

    groupingBlock := n = 1
            ifTrue: [ [ :e | e ] ]
            ifFalse: [ [ :e | e howManyOf: n ] ].
    ^ samples collect: [ :sample | groupingBlock value: sample spiedCollectionInstance size ] as: Bag
]

{ #category : 'statistics' }
Presizer >> typesDistributionGroupingBy: n [

    | groupingBlock typesPerCollection |
    self assert: n > 0.
    groupingBlock := (n = 1)
            ifTrue: [ [ :e | e ] ]
            ifFalse: [ [ :e | e howManyOf: n ] ].

    typesPerCollection := samples collect: [ :sample |
            (sample spiedCollectionInstance collect: #class as: Set) size ].

    ^ typesPerCollection collect: [ :e | groupingBlock value: e ] as: Bag
]
