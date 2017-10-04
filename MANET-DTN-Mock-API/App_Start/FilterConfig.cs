using System.Web;
using System.Web.Mvc;

namespace MANET_DTN_Mock_API
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
        }
    }
}
