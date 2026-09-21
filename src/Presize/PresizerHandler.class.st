Class {
	#name : 'PresizerHandler',
	#superclass : 'MpHandler',
	#instVars : [
		'profiler'
	],
	#category : 'Presize-Objects',
	#package : 'Presize',
	#tag : 'Objects'
}

{ #category : 'as yet unclassified' }
PresizerHandler >> afterExecutionWithReceiver: receiver returnValue: newlyAllocatedObject [

	| metaClass filteredContext callsite allocationSenderChain i n sample |
	
	(newlyAllocatedObject isKindOf: Collection) ifFalse: [ ^ newlyAllocatedObject ].
	
	metaClass := newlyAllocatedObject class class.
	i := 1.
	n := 120.
	allocationSenderChain := Array new: n.
	callsite := PresizerCallSite new.
	
	filteredContext := thisContext "this method"
		sender "proxy method".
	"Get the textual allocation site."
	[ filteredContext receiver class = metaClass ] whileTrue: [
		allocationSenderChain
			at: i put: filteredContext compiledCode;
			at: i + 1 put: filteredContext pc - 1.
		i := i + 2.
		filteredContext := filteredContext sender ].

	"Now the filtered context is at the call site of basicNew (or equivalent, basicNew: Array>>new:)"
	callsite method: filteredContext compiledCode; offset: filteredContext pc -1.
	"Get the rest of the path until a limit n"
	[ filteredContext isNil or: [ i > n ] ] whileFalse: [
		allocationSenderChain
			at: i put: filteredContext compiledCode;
		 	at: i + 1 put: filteredContext pc - 1.
		i := i + 2.
		filteredContext := filteredContext sender ].
	
	callsite path: allocationSenderChain.
	sample := PresizerSample new collectionInstance: newlyAllocatedObject; callsite: callsite; yourself.

	"Dispatch to profiler"
	profiler registerSample: sample.
	
	^ newlyAllocatedObject
]

{ #category : 'as yet unclassified' }
PresizerHandler >> profiler: aProfiler [

    profiler := aProfiler
]
