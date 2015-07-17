//
//  NavigationViewController
//
//  Class used for displaying the navigation elements
//

import WebKit


class NavigationViewController: WebViewController {

    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction,
        decisionHandler: (WKNavigationActionPolicy) -> Void) {
            print(navigationAction.request.URL!)
            if (navigationAction.request.URL!.scheme == "thepony") {
                decisionHandler(WKNavigationActionPolicy.Cancel);
                var data = [String: AnyObject]();
                data["path"] = navigationAction.request.URL!.path;
                if let query = navigationAction.request.URL!.query {
                    let queryArr = split(query.characters, isSeparator: { $0 == "&"}).map { String($0) }
                    for param in queryArr {
                        let splitParams = split(param.characters, isSeparator: { $0 == "="}).map { String($0) };
                        var name = "";
                        name = splitParams[0];
                        let isTrue = (splitParams[1] == "true");
                        data.updateValue(isTrue, forKey: name)
                    }
                }
                self.performSegueWithIdentifier("goToContent", sender: data)
                
            } else {
                 decisionHandler(WKNavigationActionPolicy.Allow);
            }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dict = sender as? Dictionary<String, AnyObject> {
            let path = dict["path"] as! String
            let landscape = dict["landscape"] as! Bool
            let specialRotate = dict["specialRotate"] as! Bool
            let needsServer = dict["needsServer"] as! Bool
            
            if let destination = segue.destinationViewController as? ContentViewController{
                destination.setUrlFromPart(path)
                destination.specialRotate = specialRotate
                destination.isLandscape = landscape
                destination.needsServer = needsServer
            }
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        print("mem warn")
    }
}
