Class {
	#name : 'PresizerCallSite',
	#superclass : 'Object',
	#instVars : [
		'method',
		'offset',
		'path'
	],
	#category : 'Presize-Objects',
	#package : 'Presize',
	#tag : 'Objects'
}

{ #category : 'instance creation' }
PresizerCallSite class >> method: aCompiledMethod offset: anInteger [

    ^ self new
          method: aCompiledMethod;
          offset: anInteger;
          yourself
]

{ #category : 'accessing' }
PresizerCallSite >> inspectorCallSite: aBuilder [

    <inspectorPresentationOrder: 0 title: 'Call Site'>
    ^ (IllMethodWithOffset method: method offset: offset) inspectorPresenter: aBuilder
]

{ #category : 'accessing' }
PresizerCallSite >> inspectorExtensionSenders: aBuilder [

	<inspectorPresentationOrder: 1 title: 'Path'>
	^ self sendersCallStack buildInspectorPresenter: aBuilder
]

{ #category : 'accessing' }
PresizerCallSite >> method [

	^ method
]

{ #category : 'accessing' }
PresizerCallSite >> method: anObject [

	method := anObject
]

{ #category : 'accessing' }
PresizerCallSite >> offset [

	^ offset
]

{ #category : 'accessing' }
PresizerCallSite >> offset: anObject [

	offset := anObject
]

{ #category : 'accessing' }
PresizerCallSite >> path [

	^ path
]

{ #category : 'accessing' }
PresizerCallSite >> path: anObject [

	path := anObject
]

{ #category : 'accessing' }
PresizerCallSite >> sendersCallStack [

	^ IllSendersCallStack senders: path
]
