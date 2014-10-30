class AssetObserver < ActiveRecord::Observer
  def after_create(asset)
    asset.attachable.updated_at = asset.created_at
    asset.attachable.save
  end
  def after_destroy(asset)
    asset.attachable.updated_at = Time.now
    asset.attachable.save
  end
end
