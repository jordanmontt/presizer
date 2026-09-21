Class {
	#name : 'Presizer',
	#superclass : 'Object',
	#instVars : [
		'instrumenter',
		'handler',
		'spiedCollections'
	],
	#category : 'Presize-Objects',
	#package : 'Presize',
	#tag : 'Objects'
}

{ #category : 'as yet unclassified' }
Presizer >> analize: aBlock [

	self instrument.
	[ aBlock value ] ensure: [ self deinstrument ]
]

{ #category : 'as yet unclassified' }
Presizer >> deinstrument [ 

	instrumenter deinstrument
]

{ #category : 'initialization' }
Presizer >> initialize [

    super initialize.
    spiedCollections := OrderedCollection new: 10000.

    handler := PresizerHandler new profiler: self; yourself.
    instrumenter := IllInstrumenter onProfiler: self instrumentationHandler: handler
]

{ #category : 'as yet unclassified' }
Presizer >> instrument [ 

	instrumenter instrument
]

{ #category : 'as yet unclassified' }
Presizer >> registerAllocation: newlyAllocatedObject withCallSite: callsite [

    spiedCollections add: newlyAllocatedObject
]

{ #category : 'as yet unclassified' }
Presizer >> registerSample: sample [

    spiedCollections add: sample
]
