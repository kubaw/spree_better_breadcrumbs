module Spree::BaseHelper
	def breadcrumbs(taxon = nil, product = nil, sep = "&nbsp;&raquo;&nbsp;")
		if String === product
			sep = product
			product = nil
		end
		
		return "" unless taxon || product || current_page?(products_path)

		session['last_crumb'] = taxon ? taxon.permalink : nil
		sep = raw(sep)
		crumbs = [content_tag(:li, link_to( content_tag(:span,  t(:home), :itemprop => "title"), root_path, :itemprop => "url") + sep, :itemtype => "http://data-vocabulary.org/Breadcrumb", :itemscope => "itemscope")]

		if taxon
			crumbs << taxon.ancestors.collect { |ancestor| content_tag(:li, link_to(content_tag(:span, ancestor.name, :itemprop => "title"), seo_url(ancestor), :itemprop => "url") + sep, :itemscope => "itemscope", :itemtype => "http://data-vocabulary.org/Breadcrumb") } unless taxon.ancestors.empty?
			if product
				crumbs << content_tag(:li, link_to(content_tag(:span, taxon.name, :itemprop => "title"), seo_url(taxon), :itemprop => "url") + sep,  :itemtype => "http://data-vocabulary.org/Breadcrumb", :itemscope => "itemscope")
				crumbs << content_tag(:li, content_tag(:span, accurate_title, :itemprop => "title"),  :itemtype => "http://data-vocabulary.org/Breadcrumb", :itemscope => "itemscope")
			else
				crumbs << content_tag(:li, content_tag(:span, taxon.name, :itemprop => "title"),  :itemtype => "http://data-vocabulary.org/Breadcrumb", :itemscope => "itemscope")
			end
		elsif product
			crumbs << content_tag(:li, link_to(content_tag(:span, t('products') , :itemprop => "title"), products_path, :itemprop => "url") + sep,  :itemtype => "http://data-vocabulary.org/Breadcrumb", :itemscope => "itemscope")
			crumbs << content_tag(:li, content_tag(:span, accurate_title, :itemprop => "title"),  :itemtype => "http://data-vocabulary.org/Breadcrumb", :itemscope => "itemscope")
		else
			crumbs << content_tag(:li, content_tag(:span, t('products'), :itemprop => "title"),  :itemtype => "http://data-vocabulary.org/Breadcrumb", :itemscope => "itemscope")
		end
		crumb_list = content_tag(:ul, raw(crumbs.flatten.map{|li| li.mb_chars}.join), :class => 'inline')
		content_tag(:div, crumb_list, :id => 'breadcrumbs')
	end
	
	def last_crumb_path
		plink = session['last_crumb']
		if plink && taxon = Spree::Taxon.find_by_permalink(plink)
			seo_url(taxon)
		else
			products_path
		end
	end
end
