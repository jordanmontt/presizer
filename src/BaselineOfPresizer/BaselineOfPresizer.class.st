Class {
	#name : 'BaselineOfPresizer',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfPresizer-BaselineOfPresizer',
	#package : 'BaselineOfPresizer',
	#tag : 'BaselineOfPresizer'
}

{ #category : 'baselines' }
BaselineOfPresizer >> baseline: spec [

    <baseline>
    spec for: #common do: [ "Packages"
            spec package: 'Presize'.

            "External dependencies"
            spec baseline: 'IllimaniProfiler'
                with: [ spec repository: 'github://jordanmontt/illimani-memory-profiler:dev' ].

            "Link external dependencies"
            spec package: 'Presize' with: [ spec requires: #( 'IllimaniProfiler' ) ].

            "Groups"
            spec group: 'default' with: #( 'core' ).
            spec group: 'core' with: #( 'Presize' ) ]
]
