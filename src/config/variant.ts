export const SITE_VARIANT: string = (() => {
  if (typeof window !== 'undefined') {
    const params = new URLSearchParams(window.location.search);
    const urlVariant = params.get('variant');
    if (urlVariant === 'tech' || urlVariant === 'full' || urlVariant === 'finance') {
      localStorage.setItem('worldmonitor-variant', urlVariant);
      return urlVariant;
    }

    const stored = localStorage.getItem('worldmonitor-variant');
    if (stored === 'tech' || stored === 'full' || stored === 'finance') return stored;
  }
  return import.meta.env.VITE_VARIANT || 'full';
})();
