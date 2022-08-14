
import UIKit

class ViewController: UIViewController {
    
    enum Section: Hashable {
        case promoted
        case standard(String)
        case categories
    }
    
    enum SupplementaryViewKind {
        static let header = "header"
        static let topLine = "topLine"
        static let bottomLine = "bottomLine"
    }

    @IBOutlet var collectionView: UICollectionView!
    
    //Model instance
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Collection View Setup
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(PromotedAppCollectionViewCell.self, forCellWithReuseIdentifier: PromotedAppCollectionViewCell.reuseIdentifier)
        collectionView.register(StandardAppCollectionViewCell.self, forCellWithReuseIdentifier: StandardAppCollectionViewCell.reuseIdentifier)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.register(LineView.self, forSupplementaryViewOfKind: SupplementaryViewKind.topLine, withReuseIdentifier: LineView.reuseIdentifier)
        collectionView.register(LineView.self, forSupplementaryViewOfKind: SupplementaryViewKind.bottomLine, withReuseIdentifier: LineView.reuseIdentifier)
        
        //optional
        configureDataSource()
    }
    //MARK: Batuhan Ipci ID: bipci
    //MARK: COMMENTS
    
    // - All classes below have prefix "NS" but not "UI" This means API is universal and can be used on iOS, MacOS, WatchOS, iPadOS
    
    // Creating an method that returns UICollectionViewLayout to build a compositional layout for CollectionView.
    func createLayout() -> UICollectionViewLayout {
        // Here we are creating an layout object and assign it to the UICollectionViewCompositionalLayout.
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
        // => We are initializing UICollectionViewCompositionalLayout with closure.
        // This closure will be called when layout changes (e.g: rotating from portrait to landscape)
            //MARK: HEADER ITEM - The title of the sections
            // headerItemSize that consist %92 width of the containing group.
            // Actual size of the height 44 will be determined when the headerItemSize is rendered. So it depends on content and flexible
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(44))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.header, alignment: .top) //Setting the location of headerItemSize
            //MARK: LINE ITEM - The top line at the very top of the promoted section
            // setting the line accordingly to the display scale (horizontal / vertical)
            let lineItemHeight = 1 / layoutEnvironment.traitCollection.displayScale
            //setting lineItemSize %92 on the width of the containing group and
            //absolute point (fixed) value of whatever the calculation lineItemHeight is
            let lineItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .absolute(lineItemHeight))
            let topLineItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: lineItemSize, elementKind: SupplementaryViewKind.topLine, alignment: .top)
            //MARK: FOOTER ITEM - Bottom line that seperates each section
            //NSCollectionLayoutBoundarySupplementaryItem lets you set the footer and headers in this case we are setting the bottom line
            let bottomLineItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: lineItemSize, elementKind: SupplementaryViewKind.bottomLine, alignment: .bottom)
            
            //Here we are setting additional spacing in the beginning and in the end for the corresponding items.
            let supplementaryItemContentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
            headerItem.contentInsets = supplementaryItemContentInsets // setting spaces for section's headers
            topLineItem.contentInsets = supplementaryItemContentInsets // setting spaces for the line at the very top
            bottomLineItem.contentInsets = supplementaryItemContentInsets// setting spaces for the lines that seperating the sections
            
            let section = self.sections[sectionIndex]// each section of the collection view
            
            switch section {
            case .promoted:
                // MARK: Promoted Section Layout
                //This .promoted case is for the file PromotedAppCollectionViewCell
                //The width and height of this item will take %100 of the containing group
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                // Set spacing at the beginning and at the end of the item
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                
                //The groupSize will take %92 of its parent.
                //As the width it will take 300 after it calculates the actual size of the promoted app's dimenstions
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(300))
                //The group will present the items in horizontal format and in subitems: we are passing the item we created above
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                //Essentially this is an group that contains all the items for the promoted section with specified sizes
                                
                //We are initializing the section as the parent of the group we have created.
                let section = NSCollectionLayoutSection(group: group)
                // orthogonalScrollingBehavior lets us to put all the groups in a scrollable position
                // as you scoll each group will be centered
                section.orthogonalScrollingBehavior = .groupPagingCentered
                // Places an line to the top and bottom as the borders of section
                section.boundarySupplementaryItems = [topLineItem, bottomLineItem]
                // Sets the spacing around the line for the top and bottom we have placed previously
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 20, trailing: 0)
                return section
                
            case .standard:
                // MARK: Standard Section
                //This .standard case is for the file StandardAppCollectionViewCell
                // items in the Standard Section will take the full width of the parent.
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/3))
                let item = NSCollectionLayoutItem(layoutSize: itemSize) // setting the size of the item
                //Seting the space of the items in this case collection of apps
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                
                //The groupSize is the group that is holding all the apps in standard section.
                // - It is taking %92 of the parent section in width.
                // - The height depends on the amount of app's dimensions and the amount of apps. It is important to set as estimated since we first need to render amount and how big the apps are in standard section and then calculate the height of the group
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(250))
                //We are stating the count of the apps we want in the group and setting the appropriate sizing we initialized above. In the groupSize the estimated plays important role to set the count of apps.
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
                let section = NSCollectionLayoutSection(group: group) // Initializing the section as parent of the group
                // setting scrollable behaviour and centers the each section of the apps as your view on the screen
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.boundarySupplementaryItems = [headerItem, bottomLineItem] //Places header title for the each section and a line underneath the section.
                //Placing spaces under the headerItem, in this case the title and spacing above the bottomLine
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 20, trailing: 0)
                
                return section
                
            case .categories:
                // MARK: Categories Section Layout
                //CategoryCollectionViewCell
                //sets %100 for both width and height of the itemSize
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                //We are using availableLayoutWidth constant to determine max sizing for the cell
                let availableLayoutWidth = layoutEnvironment.container.effectiveContentSize.width
                let groupWidth = availableLayoutWidth * 0.92 // this returns number that determines the width of each row in the categories
                let remainingWidth = availableLayoutWidth - groupWidth
                let halfOfRemainingWidth = remainingWidth / 2.0
                let nonCategorySectionItemInset = CGFloat(4)
                let itemLeadingAndTrailingInset = halfOfRemainingWidth + nonCategorySectionItemInset
                // Setting the item's padding to the result of the calculation we get from above
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: itemLeadingAndTrailingInset, bottom: 0, trailing: itemLeadingAndTrailingInset)
                //groupSize takes the full width of the parent. We are giving estimate 44 height for the each row's height within the group
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
                //NSCollectionLayoutGroup.vertical works like its horizontal counterpart. Above we have already specified that we want full width of the containing group.
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [headerItem] // setting the header title
                
                return section
            }
        }
        
        return layout
    }
    
    func configureDataSource() {
        // MARK: Data Source Initialization
        dataSource = .init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let section = self.sections[indexPath.section]
            switch section {
            case .promoted:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromotedAppCollectionViewCell.reuseIdentifier, for: indexPath) as! PromotedAppCollectionViewCell
                cell.configureCell(item.app!)
                
                return cell
            case .standard:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StandardAppCollectionViewCell.reuseIdentifier, for: indexPath) as! StandardAppCollectionViewCell
                
                let isThirdItem = (indexPath.row + 1).isMultiple(of: 3)
                cell.configureCell(item.app!, hideBottomLine: isThirdItem)
                
                return cell
            case .categories:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
                let isLastItem = collectionView.numberOfItems(inSection: indexPath.section) == indexPath.row + 1
                cell.configureCell(item.category!, hideBottomLine: isLastItem)
                
                return cell
            }
        })
        
        // MARK: Supplementary View Provider
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case SupplementaryViewKind.header:
                let section = self.sections[indexPath.section]
                let sectionName: String
                switch section {
                case .promoted:
                    return nil
                case .standard(let name):
                    sectionName = name
                case .categories:
                    sectionName = "Top Categories"
                }
                
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.header, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
                headerView.setTitle(sectionName)
                
                return headerView
                
            case SupplementaryViewKind.topLine, SupplementaryViewKind.bottomLine:
                let lineView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LineView.reuseIdentifier, for: indexPath) as! LineView
                return lineView
                
            default:
                return nil
            }
        }
        
        // MARK: Snapshot Definition
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.promoted])
        snapshot.appendItems(Item.promotedApps, toSection: .promoted)
        
        let popularSection = Section.standard("Popular this week")
        let essentialSection = Section.standard("Essential picks")
        
        snapshot.appendSections([popularSection, essentialSection])
        snapshot.appendItems(Item.popularApps, toSection: popularSection)
        snapshot.appendItems(Item.essentialApps, toSection: essentialSection)
        
        snapshot.appendSections([.categories])
        snapshot.appendItems(Item.categories, toSection: .categories)
        
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }
}

