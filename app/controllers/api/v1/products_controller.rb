require "matrix"
class Api::V1::ProductsController < ApplicationController
	before_action :set_product, only: [:show, :edit, :update, :destroy]
	protect_from_forgery with: :null_session, if: Proc.new {|c| c.request.format.json? }

	#-----------------------------------------------------------------------------------
	#
	#-----------------------------------------------------------------------------------
	def index
		if params[:length].present? or params[:width].present? or params[:height].present? or params[:weight].present?
			@products = Product.where(nil) # creates an anonymous scope
			error = false

			if params[:length].present?
	  			@products = @products.le(params[:length])
	  		else
	  			render json: {error: 'Missing param length'}, status: :unprocessable_entity
	  			error = true
	  		end

	  		if params[:width].present?
	  			@products = @products.wi(params[:width])
	  		else
				render json: {error: 'Missing param width'}, status: :unprocessable_entity
				error = true
	  		end

	  		if params[:height].present?
	  			@products = @products.he(params[:height])
	  		else
	  			render json: {error: 'Missing param height'}, status: :unprocessable_entity
	  			error = true
	  		end

	  		if params[:weight].present?
	  			@products = @products.we(params[:weight])
	  		else
	  			render json: {error: 'Missing param weight'}, status: :unprocessable_entity
	  			error = true
	  		end

	  		unless error
		  		# Get the best result for the client
		  		request = [params[:length].to_i,params[:width].to_i,params[:height].to_i,params[:weight].to_i]
		  		best=1000
		  	
		  		@products.each do |product|
		  			tmp = [product.length, product.width, product.height, product.weight]
		  			res = request.zip(tmp).map { |x, y| (y - x).abs }
		  			
		  			if res.sum<best
		  				best = res.sum
		  				@product = product
		 			end
		  		end

		  		puts best
		  		puts "------------------------------"

		  		render json: @product
		  	end

	  	else
	  		@products = Product.all
	  	end
	end


	#-----------------------------------------------------------------------------------
	#
	#-----------------------------------------------------------------------------------
	def show

	end


	#-----------------------------------------------------------------------------------
	#
	#-----------------------------------------------------------------------------------
	def create
	 	@product = Product.new(product_params)

	    respond_to do |format|
	      if @product.save
	        format.json { render :show, status: :created, location: api_v1_product_url(@product)}
	      else
	        format.json { render json: @product.errors, status: :unprocessable_entity }
	      end
	    end
	end


	#-----------------------------------------------------------------------------------
	#
	#-----------------------------------------------------------------------------------
	def update
		respond_to do |format|
	      if @product.update(product_params)
	      	format.json { render :show, status: :ok, location: api_v1_product_url(@product)}
	      else
	        format.json { render json: @product.errors, status: :unprocessable_entity }
	      end
	    end
	end


	#-----------------------------------------------------------------------------------
	#
	#-----------------------------------------------------------------------------------
	def destroy
		@product.destroy
    	respond_to do |format|
      		format.json { head :no_content }
    	end
	end


	private
		def set_product
			begin
				@product = Product.find(params[:id])
			rescue
				render json: {error: 'Record not found'}, status: :unprocessable_entity
			end
		end

    	def product_params
    		params.require(:product).permit(:name, :product_type, :length, :width, :height, :weight)
		end
end