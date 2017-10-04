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
    public class RemoveIDListsController : ApiController
    {
        private MANET_DTN_MOCKEntities db = new MANET_DTN_MOCKEntities();

        // GET: api/RemoveIDLists
        public IQueryable<RemoveIDList> GetRemoveIDLists()
        {
            return db.RemoveIDLists;
        }

        /*
        // GET: api/RemoveIDLists/5
        [ResponseType(typeof(RemoveIDList))]
        public async Task<IHttpActionResult> GetRemoveIDList(string id)
        {
            RemoveIDList removeIDList = await db.RemoveIDLists.FindAsync(id);
            if (removeIDList == null)
            {
                return NotFound();
            }

            return Ok(removeIDList);
        }

        // PUT: api/RemoveIDLists/5
        [ResponseType(typeof(void))]
        public async Task<IHttpActionResult> PutRemoveIDList(string id, RemoveIDList removeIDList)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != removeIDList.ItemID)
            {
                return BadRequest();
            }

            db.Entry(removeIDList).State = EntityState.Modified;

            try
            {
                await db.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!RemoveIDListExists(id))
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

        // POST: api/RemoveIDLists
        [ResponseType(typeof(RemoveIDList))]
        public async Task<IHttpActionResult> PostRemoveIDList(RemoveIDList removeIDList)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.RemoveIDLists.Add(removeIDList);

            try
            {
                await db.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (RemoveIDListExists(removeIDList.ItemID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = removeIDList.ItemID }, removeIDList);
        }

        // DELETE: api/RemoveIDLists/5
        [ResponseType(typeof(RemoveIDList))]
        public async Task<IHttpActionResult> DeleteRemoveIDList(string id)
        {
            RemoveIDList removeIDList = await db.RemoveIDLists.FindAsync(id);
            if (removeIDList == null)
            {
                return NotFound();
            }

            db.RemoveIDLists.Remove(removeIDList);
            await db.SaveChangesAsync();

            return Ok(removeIDList);
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

        private bool RemoveIDListExists(string id)
        {
            return db.RemoveIDLists.Count(e => e.ItemID == id) > 0;
        }
    }
}