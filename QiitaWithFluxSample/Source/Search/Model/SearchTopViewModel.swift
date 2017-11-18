//
//  SearchTopViewModel.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/16.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift
import RxCocoa
import Action
import QiitaSession

final class SearchTopViewModel {
    private let session: SessionType
    private let routeAction: RouteAction
    private let applicationAction: ApplicationAction
    
    let lastItemsRequest: Property<ItemsRequest?>
    private let _lastItemsRequest = Variable<ItemsRequest?>(nil)
    
    let items: Property<[Item]>
    private let _items = Variable<[Item]>([])
    
    let totalCount: Property<Int>
    private let _totalCount = Variable<Int>(0)
    
    let error: Property<Error?>
    private let _error = Variable<Error?>(nil)
    
    let hasNext: Property<Bool>
    private let _hasNext = Variable<Bool>(true)
    
    let searchAction: Action<ItemsRequest, ElementsResponse<Item>>
    private let perPage: Int = 20
    private let disposeBag = DisposeBag()
    
    let noResult: Observable<Bool>
    let reloadData: Observable<Void>
    let isFirstLoading: Observable<Bool>
    let keyboardWillShow: Observable<UIKeyboardInfo>
    let keyboardWillHide: Observable<UIKeyboardInfo>
    
    init(session: SessionType = QiitaSession.shared,
         routeAction: RouteAction = .shared,
         applicationAction: ApplicationAction = .shared,
         selectedIndexPath: Observable<IndexPath>,
         searchText: ControlProperty<String>,
         deleteButtonTap: ControlEvent<Void>,
         reachedBottom: Observable<Void>) {
        self.session = session
        self.routeAction = routeAction
        self.applicationAction = applicationAction
        
        self.lastItemsRequest = Property(_lastItemsRequest)
        self.items = Property(_items)
        self.error = Property(_error)
        self.totalCount = Property(_totalCount)
        self.hasNext = Property(_hasNext)
        
        self.searchAction = Action { [weak session] request in
            session.map { $0.send(request) } ?? .empty()
        }
        
        let itemsObservable = items.changed
        self.noResult = Observable.combineLatest(itemsObservable,
                                                 searchAction.executing)
            .map { !$0.isEmpty || $1 }
        
        let hasNextObservable = hasNext.changed
        self.reloadData = Observable.combineLatest(itemsObservable,
                                                   hasNextObservable)
            .map { _ in }
        
        self.isFirstLoading = Observable.combineLatest(itemsObservable,
                                                       hasNextObservable,
                                                       lastItemsRequest.changed)
            .map { $0.0.isEmpty && $0.1 && $0.2 != nil }
        
        self.keyboardWillShow = NotificationCenter.default.rx.notification(.UIKeyboardWillShow)
            .map { $0.userInfo }
            .filterNil()
            .map { UIKeyboardInfo(info: $0) }
            .filterNil()
        
        self.keyboardWillHide = NotificationCenter.default.rx.notification(.UIKeyboardWillHide)
            .map { $0.userInfo }
            .filterNil()
            .map { UIKeyboardInfo(info: $0) }
            .filterNil()
        
        selectedIndexPath
            .withLatestFrom(_items.asObservable()) { $1[$0.row] }
            .map { $0.url }
            .subscribe(onNext: { [weak routeAction] in
                routeAction?.show(searchDisplayType: .webView($0))
            })
            .disposed(by: disposeBag)
        
        searchAction.elements
            .subscribe(onNext: { [weak self] response in
                guard let me = self else { return }
                me._items.value.append(contentsOf: response.elements)
                me._totalCount.value = response.totalCount
                me._hasNext.value = (me._items.value.count < me._totalCount.value) && !response.elements.isEmpty
            })
            .disposed(by: disposeBag)
        
        searchAction.errors
            .map { Optional($0) }
            .bind(to: _error)
            .disposed(by: disposeBag)
        
        deleteButtonTap
            .subscribe(onNext: { [weak applicationAction] in
                applicationAction?.removeAccessToken()
            })
            .disposed(by: disposeBag)

        let firstLoad = searchText
            .debounce(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .do(onNext: { [weak self] _ in
                self?._lastItemsRequest.value = nil
                self?._items.value.removeAll()
                self?._hasNext.value = true
            })
            .filter { !$0.isEmpty }
            .map { ($0, 1) }
        
        let loadMore = reachedBottom
            .withLatestFrom(hasNext.asObservable())
            .filter { $0 }
            .withLatestFrom(lastItemsRequest.asObservable())
            .filterNil()
            .map { ($0.query, $0.page + 1) }

        Observable.merge(firstLoad, loadMore)
            .flatMap { [weak self] query, page -> Observable<ItemsRequest> in
                self.map { .just(ItemsRequest(page: page, perPage: $0.perPage, query: query)) } ?? .empty()
            }
            .bind(to: _lastItemsRequest)
            .disposed(by: disposeBag)
            
        _lastItemsRequest.asObservable()
            .filterNil()
            .distinctUntilChanged { $0.page == $1.page && $0.query == $1.query }
            .subscribe(onNext: { [weak self] request in
                self?.searchAction.execute(request)
            })
            .disposed(by: disposeBag)
    }
}
