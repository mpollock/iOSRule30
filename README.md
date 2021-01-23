# iOSRule30
An implementation of rule30 on iOS: https://en.wikipedia.org/wiki/Rule_30

## Dev Notes
Rule30 is meant to be implemented on an infintely large array. Since the display we're using is limited, only the middle cells will be displayed, even though the entire array must be calculated.
This requires some special assumptions that must be taken into account, which makes this less compatible with other rules such as rule60. 

Keep in mind that we're applying new rows to the top of the collectionview, not the bottom.
