//
//  DNAlbumTableViewCell.h
//
//

//----------------------------------------------------------

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

//----------------------------------------------------------

UIKIT_EXTERN NSString * const DNAlbumTableViewCellReuseIdentifier;

//----------------------------------------------------------

@interface DNAlbumTableViewCell : UITableViewCell

@property(nonatomic,strong) ALAssetsGroup * assetsAlbum;

@end
