// Auto-dismiss flash messages after 4 s
document.querySelectorAll('.alert-dismissible').forEach(el => {
  setTimeout(() => {
    const bsAlert = bootstrap.Alert.getOrCreateInstance(el);
    if (bsAlert) bsAlert.close();
  }, 4000);
});

// Confirm before any delete form submission (fallback for no inline onsubmit)
document.querySelectorAll('form[data-confirm]').forEach(form => {
  form.addEventListener('submit', e => {
    if (!confirm(form.dataset.confirm)) e.preventDefault();
  });
});

// Client-side column sorting for admin tables
document.querySelectorAll('table.sortable').forEach(table => {
  const ths = Array.from(table.querySelectorAll('thead th'));
  ths.forEach((th, colIdx) => {
    if (colIdx === ths.length - 1) return; // skip Actions column
    th.style.cursor = 'pointer';
    th.title = 'לחץ למיון';

    th.addEventListener('click', () => {
      const tbody = table.querySelector('tbody');
      const rows = Array.from(tbody.querySelectorAll('tr'));
      if (rows.length < 2 || rows[0].cells.length === 1) return;

      const asc = th.dataset.dir !== 'asc';

      ths.forEach(h => {
        h.dataset.dir = '';
        const ic = h.querySelector('.sort-icon');
        if (ic) ic.remove();
      });

      th.dataset.dir = asc ? 'asc' : 'desc';
      const icon = document.createElement('i');
      icon.className = `bi bi-caret-${asc ? 'up' : 'down'}-fill sort-icon ms-1`;
      icon.style.fontSize = '.65rem';
      th.appendChild(icon);

      rows.sort((a, b) => {
        const av = (a.cells[colIdx]?.textContent || '').trim();
        const bv = (b.cells[colIdx]?.textContent || '').trim();
        const an = parseFloat(av.replace(/[^0-9.-]/g, ''));
        const bn = parseFloat(bv.replace(/[^0-9.-]/g, ''));
        const cmp = (!isNaN(an) && !isNaN(bn))
          ? an - bn
          : av.localeCompare(bv, undefined, { numeric: true, sensitivity: 'base' });
        return asc ? cmp : -cmp;
      });

      rows.forEach(r => tbody.appendChild(r));
    });
  });
});
