Class {
	#name : 'Presizer',
	#superclass : 'IllAbstractProfiler',
	#instVars : [
		'spiedCollections'
	],
	#category : 'Presize-Objects',
	#package : 'Presize',
	#tag : 'Objects'
}

{ #category : 'initialization' }
Presizer >> initialize [

    super initialize.
    spiedCollections := OrderedCollection new: 10000
]

{ #category : 'profiling' }
Presizer >> registerAllocation: newlyAllocatedObject [

    | metaClass filteredContext callsite allocationPath i n sample |

    (newlyAllocatedObject isKindOf: Collection) ifFalse: [ ^ newlyAllocatedObject ].

    metaClass := newlyAllocatedObject class class.
    i := 1.
    n := 120.
    allocationPath := Array new: n.
    callsite := PresizerCallSite new.

    filteredContext := thisContext "this method"
            sender "IllHandler >> #afterExecutionWithReceiver:returnValue:"
            sender "proxy method".
    "Get the textual allocation site."
    [ filteredContext receiver class = metaClass ] whileTrue: [
            allocationPath
                at: i put: filteredContext compiledCode;
                at: i + 1 put: filteredContext pc - 1.
            i := i + 2.
            filteredContext := filteredContext sender ].

    "Now the filtered context is at the call site of basicNew (or equivalent, basicNew: Array>>new:)"
    callsite
        method: filteredContext compiledCode;
        offset: filteredContext pc - 1.
    "Get the rest of the path until a limit n"
    [ filteredContext isNil or: [ i > n ] ] whileFalse: [
            allocationPath
                at: i put: filteredContext compiledCode;
                at: i + 1 put: filteredContext pc - 1.
            i := i + 2.
            filteredContext := filteredContext sender ].

    callsite path: allocationPath.
    sample := PresizerSample new
                  collectionInstance: newlyAllocatedObject;
                  callsite: callsite;
                  yourself.

    spiedCollections add: sample.

    ^ newlyAllocatedObject
]
