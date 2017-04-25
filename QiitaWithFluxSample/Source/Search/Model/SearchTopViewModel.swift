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
    private var externalDisposeBag = DisposeBag()
    
    let noResult: Observable<Bool>
    let reloadData: Observable<Void>
    let isFirstLoading: Observable<Bool>
    let keyboardWillShow: Observable<UIKeyboardInfo>
    let keyboardWillHide: Observable<UIKeyboardInfo>
    
    init(session: SessionType = QiitaSession.shared,
         routeAction: RouteAction = .shared,
         applicationAction: ApplicationAction = .shared) {
        self.session = session
        self.routeAction = routeAction
        self.applicationAction = applicationAction
        
        self.lastItemsRequest = Property(_lastItemsRequest)
        self.items = Property(_items)
        self.error = Property(_error)
        self.totalCount = Property(_totalCount)
        self.hasNext = Property(_hasNext)
        
        self.searchAction = Action { [weak session] request in
            guard let session = session else { return .empty() }
            return session.send(request)
        }
        
        let itemsObservable = items.changed
        self.noResult = Observable.combineLatest(
                itemsObservable,
                searchAction.executing
            ) { $0 }
            .map { !$0.0.isEmpty || $0.1 }
        
        let hasNextObservable = hasNext.changed
        self.reloadData = Observable.combineLatest(
                itemsObservable,
                hasNextObservable
            ) { $0 }
            .map { _ in }
        
        self.isFirstLoading = Observable.combineLatest(
                itemsObservable,
                hasNextObservable,
                lastItemsRequest.changed
            ) { $0 }
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
        
        observeAction()
    }
    
    private func observeAction() {
        searchAction.elements
            .subscribe(onNext: { [weak self] response in
                guard let me = self else { return }
                me._items.value.append(contentsOf: response.elements)
                me._totalCount.value = response.totalCount
                me._hasNext.value = (me._items.value.count < me._totalCount.value) && !response.elements.isEmpty
            })
            .addDisposableTo(disposeBag)
        
        searchAction.errors
            .subscribe(onNext: { [weak self] in
                self?._error.value = $0
            })
            .addDisposableTo(disposeBag)
    }
    
    func observe(textControlProperty: ControlProperty<String?>,
                 deleteButtonTap: ControlEvent<Void>,
                 reachedBottom: Observable<Void>) {
        externalDisposeBag = DisposeBag()
        
        textControlProperty.orEmpty
            .distinctUntilChanged()
            .debounce(0.3, scheduler: ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.search(query: text)
            })
            .addDisposableTo(externalDisposeBag)
        
        deleteButtonTap
            .subscribe(onNext: { [weak self] in
                self?.removeAccessToken()
            })
            .addDisposableTo(externalDisposeBag)
        
        reachedBottom
            .subscribe(onNext: { [weak self] in
                self?.search()
            })
            .addDisposableTo(externalDisposeBag)
    }
    
    func search(query: String? = nil) {
        let nextQuery: String
        let nextPage: Int
        if let query = query {
            _lastItemsRequest.value = nil
            _items.value.removeAll()
            _hasNext.value = true
            if query.isEmpty {
                return
            }
            nextQuery = query
            nextPage = 1
        } else if hasNext.value, let lastItemsRequest = lastItemsRequest.value {
            nextQuery = lastItemsRequest.query
            nextPage = lastItemsRequest.page + 1
        } else {
            return
        }
        let request = ItemsRequest(page: nextPage, perPage: perPage, query: nextQuery)
        _lastItemsRequest.value = request
        searchAction.execute(request)
    }
    
    func showItem(rowAt indexPath: IndexPath) {
        let item = items.value[indexPath.row]
        guard let url = URL(string: item.url) else { return }
        routeAction.show(searchDisplayType: .webView(url))
    }
    
    func removeAccessToken() {
        applicationAction.removeAccessToken()
    }
}
