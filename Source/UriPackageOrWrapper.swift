//
//  UriPackageOrWrapper.swift
//  
//
//  Created by Cesar Brazon on 20/6/23.
//

import Foundation
import PolywrapClientNativeLib

public class UriValue: FfiUriPackageOrWrapper {
    var uriValue: Uri
    
    init(uriValue: Uri) {
        self.uriValue = uriValue
    }
    
    public func getKind() -> FfiUriPackageOrWrapperKind {
        return .uri
    }
    
    public func asUri() -> FfiUri {
        return uriValue.ffi
    }
    
    public func asWrapper() -> FfiUriWrapper {
        fatalError("Not a wrapper")
    }
    
    public func asPackage() -> FfiUriWrapPackage {
        fatalError("Not a package")
    }
}

public class UriWrapPackage: UriValue, FfiUriWrapPackage {
    var pkg: FfiWrapPackage
    
    init(uriValue: Uri, pkg: FfiWrapPackage) {
        self.pkg = pkg
        super.init(uriValue: uriValue)
    }
    
    override public func getKind() -> FfiUriPackageOrWrapperKind {
        return .package
    }
    
    public func getUri() -> FfiUri {
        return uriValue.ffi
    }
    
    public func getPackage() -> FfiWrapPackage {
        return pkg
    }
}

public class UriWrapper: UriValue, FfiUriWrapper {
    var wrap: FfiWrapper
    
    public init(uriValue: Uri, wrap: FfiWrapper) {
        self.wrap = wrap
        super.init(uriValue: uriValue)
    }
    
    public override func getKind() -> FfiUriPackageOrWrapperKind {
        return .wrapper
    }
    
    public func getUri() -> FfiUri {
        return uriValue.ffi
    }
    
    public func getWrapper() -> FfiWrapper {
        return wrap
    }
}
