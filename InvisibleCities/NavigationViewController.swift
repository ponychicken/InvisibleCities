//
//  NavigationViewController
//
//  Class used for displaying the nvaigation elements
//

import WebKit

#if DEBUG
    let startURL = "http://pony.local:8000/"
#else
    let startURL = "http://localhost:8116/navigation/index.html"
#endif

class NavigationViewController: WebViewController, WKNavigationDelegate {

    func webView(webView: WKWebView!, decidePolicyForNavigationAction navigationAction: WKNavigationAction,
        decisionHandler: (WKNavigationActionPolicy) -> Void) {
            println(navigationAction.request.URL.scheme)
            if (navigationAction.request.URL.scheme == "thepony") {
                decisionHandler(WKNavigationActionPolicy.Cancel);
                var data = [String: AnyObject]();
                data["path"] = navigationAction.request.URL.path;
                if let query = navigationAction.request.URL.query {
                    let queryArr = split(query, { $0 == "&"})
                    for param in queryArr {
                        let splitParams = split(param, { $0 == "="});
                        var name = "";
                        name = splitParams[0];
                        var isTrue = (splitParams[1] == "true");
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
            let path = dict["path"] as String;
            let landscape = dict["landscape"] as Bool;
            let specialRotate = dict["specialRotate"] as Bool;
            
            if let destination = segue.destinationViewController as? ContentViewController{
                destination.setUrlFromPart(path)
                destination.setSpecialRotate(specialRotate)
            }
        }
    }
}
