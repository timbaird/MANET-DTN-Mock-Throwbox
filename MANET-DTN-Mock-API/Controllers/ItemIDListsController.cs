using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using MANET_DTN_Mock_API;

namespace MANET_DTN_Mock_API.Controllers
{
    public class ItemIDListsController : ApiController
    {
        private MANET_DTN_MOCKEntities db = new MANET_DTN_MOCKEntities();

        // GET: api/ItemIDLists
        public IQueryable<ItemIDList> GetItemIDLists()
        {
            return db.ItemIDLists;
        }

        /*
        // GET: api/ItemIDLists/5
        [ResponseType(typeof(ItemIDList))]
        public async Task<IHttpActionResult> GetItemIDList(string id)
        {
            ItemIDList itemIDList = await db.ItemIDLists.FindAsync(id);
            if (itemIDList == null)
            {
                return NotFound();
            }

            return Ok(itemIDList);
        }

        // PUT: api/ItemIDLists/5
        [ResponseType(typeof(void))]
        public async Task<IHttpActionResult> PutItemIDList(string id, ItemIDList itemIDList)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != itemIDList.ItemID)
            {
                return BadRequest();
            }

            db.Entry(itemIDList).State = EntityState.Modified;

            try
            {
                await db.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ItemIDListExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return StatusCode(HttpStatusCode.NoContent);
        }

        // POST: api/ItemIDLists
        [ResponseType(typeof(ItemIDList))]
        public async Task<IHttpActionResult> PostItemIDList(ItemIDList itemIDList)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.ItemIDLists.Add(itemIDList);

            try
            {
                await db.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (ItemIDListExists(itemIDList.ItemID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = itemIDList.ItemID }, itemIDList);
        }

        // DELETE: api/ItemIDLists/5
        [ResponseType(typeof(ItemIDList))]
        public async Task<IHttpActionResult> DeleteItemIDList(string id)
        {
            ItemIDList itemIDList = await db.ItemIDLists.FindAsync(id);
            if (itemIDList == null)
            {
                return NotFound();
            }

            db.ItemIDLists.Remove(itemIDList);
            await db.SaveChangesAsync();

            return Ok(itemIDList);
        }
        */

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool ItemIDListExists(string id)
        {
            return db.ItemIDLists.Count(e => e.ItemID == id) > 0;
        }
    }
}