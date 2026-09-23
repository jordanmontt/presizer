Class {
	#name : 'PresizerSample',
	#superclass : 'Object',
	#instVars : [
		'spiedCollectionInstance',
		'allocationPath'
	],
	#category : 'Presize-Objects',
	#package : 'Presize',
	#tag : 'Objects'
}

{ #category : 'accessing' }
PresizerSample >> allocationPath [

	^ allocationPath
]

{ #category : 'accessing' }
PresizerSample >> allocationPath: anObject [

	allocationPath := anObject
]

{ #category : 'accessing' }
PresizerSample >> inspectorPath: aBuilder [

	<inspectorPresentationOrder: 1 title: 'Allocation Path'>
	^ self sendersCallStack buildInspectorPresenter: aBuilder
]

{ #category : 'accessing' }
PresizerSample >> sendersCallStack [

	^ IllSendersCallStack senders: allocationPath
]

{ #category : 'accessing' }
PresizerSample >> spiedCollectionInstance [

	^ spiedCollectionInstance
]

{ #category : 'accessing' }
PresizerSample >> spiedCollectionInstance: anObject [

	spiedCollectionInstance := anObject
]
