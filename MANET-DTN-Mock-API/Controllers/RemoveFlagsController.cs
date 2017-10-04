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
    public class RemoveFlagsController : ApiController
    {
        private MANET_DTN_MOCKEntities db = new MANET_DTN_MOCKEntities();

        // GET: api/RemoveFlags
        public IQueryable<RemoveFlag> GetRemoveFlags()
        {
            return db.RemoveFlags;
        }

        // GET: api/RemoveFlags/5
        [ResponseType(typeof(RemoveFlag))]
        public async Task<IHttpActionResult> GetRemoveFlag(string id)
        {
            RemoveFlag removeFlag = await db.RemoveFlags.FindAsync(id);
            if (removeFlag == null)
            {
                return NotFound();
            }

            return Ok(removeFlag);
        }

        // PUT: api/RemoveFlags/5
        [ResponseType(typeof(void))]
        public async Task<IHttpActionResult> PutRemoveFlag(string id, RemoveFlag removeFlag)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != removeFlag.ItemID)
            {
                return BadRequest();
            }

            db.Entry(removeFlag).State = EntityState.Modified;

            try
            {
                await db.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!RemoveFlagExists(id))
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

        // POST: api/RemoveFlags
        [ResponseType(typeof(RemoveFlag))]
        public async Task<IHttpActionResult> PostRemoveFlag(RemoveFlag removeFlag)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.RemoveFlags.Add(removeFlag);

            try
            {
                await db.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (RemoveFlagExists(removeFlag.ItemID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = removeFlag.ItemID }, removeFlag);
        }

        // DELETE: api/RemoveFlags/5
        [ResponseType(typeof(RemoveFlag))]
        public async Task<IHttpActionResult> DeleteRemoveFlag(string id)
        {
            RemoveFlag removeFlag = await db.RemoveFlags.FindAsync(id);
            if (removeFlag == null)
            {
                return NotFound();
            }

            db.RemoveFlags.Remove(removeFlag);
            await db.SaveChangesAsync();

            return Ok(removeFlag);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool RemoveFlagExists(string id)
        {
            return db.RemoveFlags.Count(e => e.ItemID == id) > 0;
        }
    }
}