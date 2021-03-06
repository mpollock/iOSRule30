# iOSRule30
An implementation of rule30 on iOS: https://en.wikipedia.org/wiki/Rule_30

## Dev Notes
Rule30 is meant to be implemented on an infintely large array. Since the display we're using is limited, only the middle cells will be displayed, even though the entire array must be calculated.
This requires some special assumptions that must be taken into account, which makes this less compatible with other rules such as rule60. 

Keep in mind that we're applying new rows to the top of the collectionview, not the bottom, so the pattern looks opposite but is correct. I almost messed this up when simply flipping the normal pattern upside-down to compare to my generated pattern, since they won't map up. To do a true comparison, you have to do a reflection, not a 180 spin.

UICollectionViews are not designed for this type of large data, however I wanted to use it instead of SpriteKit since it's much more applicable to my day-to-day. This means that when making the grid larger and more dense, we're likely to experience visual lag.
