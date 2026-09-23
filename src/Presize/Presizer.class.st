Class {
	#name : 'Presizer',
	#superclass : 'IllAbstractProfiler',
	#instVars : [
		'spiedCollections',
		'traversalDepth'
	],
	#classVars : [
		'CollectionClassestoSpy'
	],
	#category : 'Presize-Objects',
	#package : 'Presize',
	#tag : 'Objects'
}

{ #category : 'accessing' }
Presizer class >> collectionClassesToSpy [

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

    CollectionClassestoSpy := self collectionClassesToSpy
]

{ #category : 'initialization' }
Presizer >> initialize [

    super initialize.
    spiedCollections := OrderedCollection new: 10000.
    traversalDepth := 80 "depth is half of the size, so 40 in this case. This is because the compiled method and the offset use two array positions. See registerAllocation: method"
]

{ #category : 'profiling' }
Presizer >> registerAllocation: newlyAllocatedObject [

    | filteredContext allocationPath i sample |

    (CollectionClassestoSpy includes: newlyAllocatedObject class) ifFalse: [ ^ newlyAllocatedObject ].

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

    spiedCollections add: sample.

    ^ newlyAllocatedObject
]
