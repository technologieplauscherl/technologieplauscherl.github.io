---
---

const CACHE_NAME = 'technologieplauscherl-page-cache';

const timeout = (duration) =>
  new Promise((resolve, reject) =>
    setTimeout(reject, duration)
  );

let prefetched = {% include prefetched.json.liquid %};

const onInstall = async () => {

  await caches.delete(CACHE_NAME);

  let cache = await caches.open(CACHE_NAME);

  await cache.addAll(prefetched);

};

const onFetch = async (eventArgs) => {

  let cache = await caches.open(CACHE_NAME);
  let response = new Response('', { status: 404 });

  try {

    let request = eventArgs.request.clone();

    response = await Promise.race([
      fetch(request),
      timeout(3000)
    ]);

    let url = request.url;

    await cache.put(url, response.clone());

  } catch (ex) {

    let request = eventArgs.request.clone();
    response = await cache.match(request.url, { ignoreSearch: true, ignoreVary: true });

  } finally {

    return response;

  }

};

self.addEventListener('install', (eventArgs) => eventArgs.waitUntil(onInstall()));
self.addEventListener('fetch', (eventArgs) => eventArgs.respondWith(onFetch(eventArgs)));
